# PeakMiner HTTP API

The miner serves a small JSON API on `--api-port` / `-a`. A bare port binds
`127.0.0.1` (`-a 4068`); `-a 0.0.0.0:4068` opens it to the LAN and to the Docker
host, and `-a 0` turns it off. Everything in and out is JSON.

This is the contract the HiveOS and mmpOS stats scripts in the release package
build on. Fields are only ever added, never renamed or removed, so a client that
ignores keys it does not know keeps working across releases.

Read access is as old as the miner. The API key and the control endpoints are
new in v2.20.0 and are off until you ask for them:

```bash
peakminer -c pearl -o stratum+tcp://pool:3360 -u <WALLET>.<WORKER> \
  -a 0.0.0.0:4068 --api-key s3cret --api-control pause,pool,config,oc \
  --state-dir /data
```

## Authentication

| Flag | Effect |
|---|---|
| none | The API is open to anyone who can reach the port. This is the behaviour of every release before v2.20.0, and it is fine on `127.0.0.1`. |
| `--api-key <secret>` (`PEAK_API_KEY`) | Every route except `GET /health` needs the key, as `X-API-Key: <secret>` **or** `Authorization: Bearer <secret>`. A missing or wrong key gets `401` with `WWW-Authenticate: Bearer`. An empty value counts as unset, which keeps the docker-compose `${API_KEY:-}` idiom working. |

The key travels in a header, never in a query string, where it would end up in
proxy and shell history. Binding the API off-host without a key still starts
the miner, so existing flight sheets keep working, but it logs a warning at
startup. Set the key before you open the port.

## Read endpoints

### `GET /health`

Never authenticated, so a container `HEALTHCHECK` or a "miner reachable" sensor
does not need the secret:

```json
{"ok": true, "version": "2.20.0"}
```

### `GET /summary`

The live stats. All hashrate fields are in **hashes per second**; the HiveOS and
mmpOS stats scripts are what divide by 1000 for the dashboards that want kH/s.
The `pool` object always carries the identity you typed on the command line,
never the dev-fee session's. The field names below are exactly what the miner
emits; the values are illustrative:

```jsonc
{
  "version": "2.20.0", "algo": "pearl", "uptime": 3600, "dev_fee_percent": 2.0,
  "hashrate": 356959884.5, "power_w": 230, "hashrate_per_watt": 1551999.4,
  "accepted_shares": 12, "invalid_shares": 0, "efficiency_pct": 100.0,
  "last_share_at": 1792666769, "eta_share_secs": 51.1, "effort_pct": 4.4,
  "pool": {
    "url": "pool:3360", "ping_ms": 215, "difficulty": 1.8e10, "connected": true,
    "user":   "<WALLET>.rig01",    // -u verbatim
    "wallet": "<WALLET>",          // the address part of -u, up to the first . or =
    "worker": "rig01",             // null when the rig has no worker name
    "index":  0,                   // which entry of `pools` is live; null before the first connect
    "pools":  ["pool:3360", "backup:3360"]
  },
  "gpus": [
    {"id": 0, "name": "RTX 4060", "pci_bus_id": "06:00.0", "utilization_pct": 100,
     "hashrate": 277679904.4, "hashrate_per_watt": 2435788.6,
     "accepted_shares": 7, "invalid_shares": 0,
     "temperature_c": 78, "fan_pct": 73, "power_w": 114,
     "mem_clock_mhz": 810, "core_clock_mhz": 2685,
     "status": null}                         // "paused" while the card is held, null while mining
  ]
}
```

## Control endpoints

`--api-control <levels>` (`PEAK_API_CONTROL`) takes a comma separated list of
`pause`, `pool`, `config` and `oc`, or `all`. Every level is off by default.

Each level needs `--api-key` and an enabled `-a`. With a control level on and no
key the miner **refuses to start**: a write surface is never merely warned
about. A level that is off answers `404`, not `403`. The one exception is
`PUT /config`, which answers `405` when the `config` level is off, because
`GET /config` keeps that path routed at every level.

Writes are serialised, one at a time. Each one is logged with the address that
sent it. Each one is also debounced, and a write that arrives too soon gets
`429` with `Retry-After` and changes nothing.

Any level also enables the two read routes below.

### `GET /config`

The running configuration, as an explicit allowlist. The password, the API key
and any proxy credentials are never in it:

```jsonc
{
  "coin": "pearl", "pools": ["stratum+tcp://pool:3360"], "user": "<WALLET>.rig01",
  "wallet": "<WALLET>", "worker": "rig01", "devices": "all", "dry_run": false,
  "api": {"bind": "0.0.0.0:4068", "key_set": true, "control": ["pause","pool","config","oc"]},
  "proxy": null,
  "source": {"coin": "cli", "pools": "cli", "user": "cli", "worker": "api"},  // cli = a flag, api = the overlay
  "overlay": {"path": "/data/peakminer.overlay.json", "written_at": "2026-10-22 10:59:57",
              "by": "192.168.1.20:37200", "fields": ["worker"], "oc_devices": [0], "error": null}
}
```

`overlay` is `null` when the miner is running purely on its flags.

### `GET /control/state`

```json
{"gpus": [{"id": 0, "paused": false, "paused_by": []},
          {"id": 1, "paused": true,  "paused_by": ["thermal", "api"]}],
 "pool_index": 0, "pool_count": 2}
```

`paused_by` names every reason holding a card (`thermal`, `schedule`, `api`). An
API resume clears only the `api` reason, so a card a temperature limit is
holding stays parked. Read this before you report a card as stuck.

### Level `pause`

| Call | Body | Result |
|---|---|---|
| `POST /control/pause` | `{"gpus":[1]}`, or `{}` for every card | `200` `[{"id":1,"paused":true,"paused_by":["api"]}]` |
| `POST /control/resume` | the same | `200` with whatever reasons are left per GPU |

An unknown GPU id gets `400` and nothing is applied. The debounce is 10 seconds
per GPU, so another card can be parked straight away. A parked card reports
`hashrate: 0` and `status: "paused"` in `/summary`.

### Level `pool`

| Call | Body | Result |
|---|---|---|
| `POST /control/pool` | `{"index": 1}` or `{"action": "next"}` / `{"action": "prev"}` | `200` `{"index":1,"url":"…","changed":true}` |

The same move as the `l` and `h` hotkeys. Already on that pool answers
`changed: false`; an index out of range is `400`; with a single pool configured
there is nothing to switch to and the answer is `409`.

### Level `config`: coin, pools, user, worker

A running miner cannot swap these in place, so the change is written to an
overlay file and the miner restarts itself: the worker process exits, the
built-in supervisor brings it back at once, and the new process reads the
overlay. Expect the API to be gone for a few seconds and poll `/health` until
it answers again.

| Call | Result |
|---|---|
| `PUT /config`, any subset of `{"coin","pools":[…],"user","worker"}` | `202` `{"restart":true,"overlay":{…}}`, then the restart |
| `DELETE /config/overlay` | `202`, back to the flags, then the restart |
| `DELETE /config/overlay?part=config` | drops only the config part and keeps the OC part, then the restart |
| `DELETE /config/overlay?part=oc` | `200` `{"restart":false,"overlay":null}`: every API overclock profile is undone in place, no restart |

Validation runs before anything is written. An unknown coin, an unparsable pool
URL, an empty user or whitespace in a worker name all get
`400 {"error":…,"field":…}` and change nothing. A key that is not in the list
above gets `422`.

**The overlay wins over the command line** for the fields it sets, and
`GET /config` says which is which per field in `source`. One flag keeps
precedence: a `-u` that already carries a worker after a `.` or a `/` still
provides the worker name, exactly as it does over `-w`, so an overlay `worker`
has no effect on such a rig.

The debounce is 60 seconds. The supervisor also counts how many reconfigure
restarts an hour has seen and starts refusing with `429` when a rig thrashes.

The overlay is `peakminer.overlay.json`, mode 0600, in `--state-dir`
(`PEAK_STATE_DIR`), or in the working directory when that flag is not set. Under
Docker point it at a mounted volume, or the reconfiguration is lost the moment
the container is recreated. The file is read only while the `config` or `oc`
level is on: a leftover overlay with the levels off is logged and ignored.

### Level `oc`: clocks, power limit, fan

Applied in place, no restart.

```
GET    /control/oc           every selected GPU
PUT    /control/oc/{gpu}     replace this GPU's whole profile
PATCH  /control/oc/{gpu}     change some knobs of the profile the API set
DELETE /control/oc/{gpu}     back to what the command line says, or stock
```

Body for `PUT` and `PATCH`. Every field is optional and `null` clears a knob:

```jsonc
{"core": 100, "lcore": 1800, "mem": 1200, "lmem": 5001,
 "power": 230,                       // watts, or "80%" of the card's own default limit
 "fan": {"duty": 70}}                // or {"target": 65, "min": 30, "max": 90}, or null for the automatic curve
```

The response, which is also the shape of each `GET /control/oc` entry:

```jsonc
{"id": 0, "source": "api",           // cli | bench | api | none
 "profile": {"core": 100, "lcore": null, "mem": null, "lmem": null, "power": "80%"},
 "applied": ["core=+100 MHz", "power=298 W", "device 0: fan pinned at 70% (2 fan(s))"],
 "skipped": [],                      // what the driver refused, e.g. "power limit 50 W out of range [123-145 W]"
 "fan": {"duty": 70}}
```

Rules:

- **One author per GPU.** `PUT` replaces the whole clock profile whatever set
  it, so a knob you leave out goes back to stock. `PATCH` merges into a profile
  the API itself set; on a card whose profile came from the `--gpu-*` flags or
  from the OC bench it answers `409` and hands you that profile, so you can send
  a `PUT` with the whole profile you want. The fan is independent: leaving `fan`
  out never touches it.
- **The driver validates the values, not the miner.** A knob the card will not
  take is listed in `skipped` and the rest still applies, with `200`. If nothing
  applies at all the answer is `422` and the card is left at stock.
- **No restart.** The same code path the `--gpu-*` flags use. The API's profile
  is kept in the overlay and re-applied after any restart.
  `DELETE /control/oc/{gpu}` puts the card back on its typed flags.
- The debounce is 60 seconds per GPU across `PUT`, `PATCH` and `DELETE`.
- The miner never tunes by itself. It applies the value you send and logs it
  with your address. Clock and power writes need the miner to run as root on
  Linux, or elevated on Windows, exactly as the flags do.

## Mapping the API to a dashboard

| What you want on screen | Where it comes from |
|---|---|
| a "miner reachable" indicator | `GET /health` |
| rig and per-GPU readings | `GET /summary` |
| wallet and worker | `pool.wallet`, `pool.worker` |
| mining on or off, per rig or per GPU | `POST /control/pause` and `/control/resume`, state from `GET /control/state` |
| a pool picker | options from `pool.pools`, current from `pool.index`, set with `POST /control/pool {"index":…}` |
| power limit, core, mem and fan per GPU | `PATCH /control/oc/{gpu}` one knob at a time; on `409` show that the flight sheet set it and offer a whole `PUT`; re-read `GET /control/oc` |
| coin, wallet, worker and the pool list | `PUT /config`, expect `202`, then poll `/health` until the new process answers |
| a "back to the flight sheet" button | `DELETE /config/overlay` |

## Status codes

| Code | Meaning |
|---|---|
| 200 | done, applied in place |
| 202 | accepted, the miner is restarting itself |
| 400 | bad value; `field` names the input |
| 401 | the key is missing or wrong |
| 404 | the level for this route is off |
| 405 | `PUT /config` while the `config` level is off (the path stays routed for `GET /config`) |
| 409 | not applicable right now: a single pool, a cli or bench profile on `PATCH`, a surface the rig does not have |
| 422 | an unknown JSON key, or an overclock profile the driver took nothing of |
| 429 | debounced or capped; `Retry-After` says for how long |

Error bodies are `{"error":"…"}`, and `400` adds `"field"`. The one exception is
the `422` for an unknown JSON key, which answers with the deserializer's own
plain-text line (`content-type: text/plain`) naming the key it did not expect.

