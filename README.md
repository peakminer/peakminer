# PeakMiner — Multi-Coin GPU Miner for NVIDIA & AMD

[![Latest release](https://img.shields.io/github/v/release/peakminer/peakminer)](https://github.com/peakminer/peakminer/releases)
[![GitHub downloads](https://img.shields.io/github/downloads/peakminer/peakminer/total?label=downloads&logo=github)](https://github.com/peakminer/peakminer/releases)
[![Docker pulls](https://img.shields.io/docker/pulls/peakminer/peakminer)](https://hub.docker.com/r/peakminer/peakminer)
[![License](https://img.shields.io/badge/license-proprietary-lightgrey)](LICENSE)
[![Telegram](https://img.shields.io/badge/Telegram-peakminer__official-26A5E4?logo=telegram&logoColor=white)](https://t.me/peakminer_official)
[![Discord](https://img.shields.io/badge/Discord-join-5865F2?logo=discord&logoColor=white)](https://discord.gg/d5gVybewQ9)
[![Announcements](https://img.shields.io/badge/Announcements-channel-26A5E4?logo=telegram&logoColor=white)](https://t.me/peakminer_announcements)

PeakMiner is a high-performance, multi-coin cryptocurrency GPU miner engineered for
maximum hashrate, low power draw, and low VRAM usage — with mining kernels tuned for each
NVIDIA and AMD GPU generation. Runs on Windows, Linux, HiveOS and Docker over
Stratum V1, with auto-detected TLS/SSL and pool failover.

> ⛏️ [See all supported coins, algorithms & dev fees →](#supported-coins--dev-fees)
> · [Supported GPUs →](#supported-gpus)
> New coins are added regularly — [follow announcements](https://t.me/peakminer_announcements).

This repository hosts the official release packages. Download the latest build from the [**Releases**](../../releases) page.

## Table of contents

- [Highlights](#highlights)
- [CLI reference](#cli-reference)
- [Supported coins & dev fees](#supported-coins--dev-fees)
- [Supported GPUs](#supported-gpus)
- [Supported pools](#supported-pools)
- [Quick start (HiveOS)](#quick-start-hiveos)
- [Quick start (Windows)](#quick-start-windows)
- [Run with Docker](#run-with-docker)
- [Mining ParanO(1)d (NOID)](#mining-parano1d-noid)
- [Mining CSD / Midstate / Alphanumeric (CLI)](#mining-csd--midstate--alphanumeric-cli)
- [Overclocking & temperature limits](#overclocking--temperature-limits)
- [Stats & logs](#stats--logs)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Highlights

- **Multi-coin** — mine **Pearl (PRL)**, **CSD**, **Midstate (MDS)** or **Alphanumeric (ALP)** over Stratum V1, with **auto-detected TLS/SSL** and failover pools
- **[ParanO(1)d (NOID)](#mining-parano1d-noid), your way** — mine it on a **public pool** with nothing to set up (**3%** miner fee), or **solo** against your own full node + Stratum V2 pool from [peakpool](https://github.com/peakminer/peakpool), brought up in one `docker compose`, where every block your farm finds pays **your** wallet in full — no account, no balance held by anyone, no withdrawal, and **0% miner fee**
- **Luck & effort stats** — see the % of expected effort used to find each share, plus running luck
- **Tuned CUDA kernels per GPU generation** — best efficiency on RTX 50xx, 40xx, 30xx and 20xx: high hash, low watt, low VRAM
- **Overclocking & thermal limits** — per-GPU core/memory clocks, power limit, and automatic temperature pause/resume
- **Windows, Linux & Docker** — standalone Windows build (`.zip`), a ready-to-go HiveOS package, and a prebuilt image (`peakminer/peakminer`)
- **Built-in HTTP stats API** — per-GPU hashrate, temperature, fan, shares, and uptime on the HiveOS dashboard

## CLI reference

**Copy-paste test runs (Linux)** — one block per coin: downloads the binary, makes it executable
and starts mining right away. They mine to our test wallets — swap in your own wallet to keep the
proceeds. On Windows, grab the zip from [Releases](../../releases) and run `peakminer.exe` with
the same `--coin` / `-o` / `-u` flags.

**Pearl (PRL):**

```bash
wget -q https://github.com/peakminer/peakminer/releases/download/v2.14.0/peakminer-2.14.0-linux-x86_64 -O peakminer && \
chmod +x peakminer && \
./peakminer --coin pearl -o de.pearl.herominers.com:1200 \
  -u prl1p8z8xpum3f8hahwhtcqq5xsk7t3n39g9uefheapcgvcexy4gcg35sdl0kcl.test
```

**CSD:**

```bash
wget -q https://github.com/peakminer/peakminer/releases/download/v2.14.0/peakminer-2.14.0-linux-x86_64 -O peakminer && \
chmod +x peakminer && \
./peakminer --coin csd -o csd-ca.lproute.com:8760 \
  -u 0x288aaabf2169f644b7126d8efcf641a18843a70e.test
```

**Midstate (MDS):**

```bash
wget -q https://github.com/peakminer/peakminer/releases/download/v2.14.0/peakminer-2.14.0-linux-x86_64 -O peakminer && \
chmod +x peakminer && \
./peakminer --coin midstate -o eu.lproute.com:8960 \
  -u 3a665ea3b2371272b7462354211d891b3a9ce8d7316eb3c9a9ca1133e422eb1e8bc6643d.test
```

**Alphanumeric (ALP):**

```bash
wget -q https://github.com/peakminer/peakminer/releases/download/v2.14.0/peakminer-2.14.0-linux-x86_64 -O peakminer && \
chmod +x peakminer && \
./peakminer --coin alphanumeric -o sg.lproute.com:4260 \
  -u 573e560a3e1324b4413a5cbd983f3e668b22218d.test
```

The flags you'll actually reach for:

| Flag | What it does |
|---|---|
| `-o, --url <url>` | Pool URL. **Repeat it for automatic failover** — the miner moves to the next pool on its own when one goes down. TLS/SSL auto-detected |
| `-u, --user <wallet>` | Pool login, **sent verbatim** — type exactly what your pool documents (`wallet`, `wallet.worker`, `wallet/worker`, …) |
| `-w, --worker <name>` | Worker name as a **separate field**. Ignored when `-u` already carries a `.` or `/` |
| `-c, --coin <name>` | Coin / algorithm: `pearl`, `csd`, `midstate`, `alphanumeric` or `parano1d` (required) |
| `-d, --devices <list>` | GPU subset, e.g. `0,1` (default: all) |
| `-a, --api-port <[host:]port>` | HTTP stats API. A bare port binds localhost; `0.0.0.0:4068` exposes it to Docker / the LAN (default 4068, `0` disables) |
| `-j, --job-timeout <secs>` | Reconnect if the pool pushes no new job for N seconds (default 180) |
| `-L, --legacy-auth` | Pin standard Stratum V1 array authorize (auto-detected by default) |
| `-f, --log-file <path>` | Also write logs to a file (`--log-append` to keep them across restarts) |
| `--dns-over-https <on\|off\|strict>` | Resolve pool hostnames over DoH — for ISPs that hijack/filter pool domains (default `off`) |
| `--proxy <socks5://…>` | Send **all** outbound traffic through a SOCKS5 proxy — no silent direct fallback |
| `--oc-profile <spec>` | Apply an overclock profile at startup: `eco`, `balanced`, `max`, or a profile id from [oc.peakminer.org](https://oc.peakminer.org). Per-GPU: `--oc-profile-gpu0 eco` (off by default) |

Every flag also has a `PEAK_*` environment-variable equivalent (shown in the help text) — handy
for Docker and scripts. Overclocking, fan and thermal flags are covered in
[Overclocking & temperature limits](#overclocking--temperature-limits).

### Multiple pools & failover

Pass `-o` as many times as you like. The miner mines the first pool that answers and **fails over
to the next one on its own** when a pool goes down — nothing to enable:

```bash
peakminer --coin pearl -u <WALLET>.<WORKER> \
  -o de.pearl.herominers.com:1200 \
  -o pearl.luckypool.io:3360 \
  -o prl.kryptex.network:7048
```

With more than one pool configured you can also switch by hand while mining — press **`l`** for the
next pool, **`h`** for the previous one, in the miner console. (Needs an interactive console; under
HiveOS or a detached Docker container there is no keyboard attached, so failover does the work.)

The `PEAK_POOL` environment variable takes the same list, comma-separated.

### Mining through a SOCKS5 proxy

`--proxy` routes **every** outbound connection through the proxy — pool sessions, DNS lookups and
the metrics push. There is **no silent fallback to a direct connection**: if the proxy is
unreachable the miner says so instead of leaking traffic around it.

```bash
peakminer --coin pearl -u <WALLET>.<WORKER> -o poolhost:port \
  --proxy socks5://127.0.0.1:1080
```

Credentials, three ways:

```bash
# inline in the URL
--proxy socks5://myuser:mypass@proxyhost:1080

# separate flags — for passwords with characters that break a URL
--proxy socks5://proxyhost:1080 --proxy-user myuser --proxy-pass mypass

# environment variables — safest, nothing lands in the process list
export PEAK_PROXY=socks5://proxyhost:1080
export PEAK_PROXY_USER=myuser
export PEAK_PROXY_PASS=mypass
```

`--proxy-user` / `--proxy-pass` win over credentials embedded in the URL. A password on the command
line is visible to anyone who can run `ps` on the rig, so prefer the environment variables on shared
or hosted machines.

`--proxy-dns remote` (the default) lets the proxy resolve pool hostnames, so the name never touches
the local resolver and a pool that only exists on the proxy's side of the network still works.
`--proxy-dns local` resolves on the rig instead.

Full `--help` output (v2.14.0):

```text
 ____            _    __  __ _
|  _ \ ___  __ _| | _|  \/  (_)_ __   ___ _ __
| |_) / _ \/ _` | |/ / |\/| | | '_ \ / _ \ '__|
|  __/  __/ (_| |   <| |  | | | | | |  __/ |
|_|   \___|\__,_|_|\_\_|  |_|_|_| |_|\___|_|
# high-performance GPU miner · v2.14.0
(c) 2026 PeakMiner — proprietary, all rights reserved; no reverse engineering / redistribution (see LICENSE). build=20260828-c6bd66
Multi-algorithm Stratum V1 miner

Usage: peakminer [OPTIONS] --url <url> --user <wallet> --coin <name>

Options:
  -h, --help     Print help
  -V, --version  Print version

Connection:
  -o, --url <url>        Pool URL. Repeatable for failover (tried in order). stratum+tcp://host:port
                         or stratum+ssl://host:port (the PEAK_POOL env form takes a comma-separated
                         list). With more than one pool, press 'l' / 'h' in the console to switch to
                         the next / previous pool without restarting [env: PEAK_POOL]
  -u, --user <wallet>    Pool login, sent VERBATIM — never split. Type exactly what your pool
                         documents (bare address, wallet.worker, wallet/worker, wallet=diff...). Use
                         --worker to fill the separate worker field instead [env: PEAK_WALLET]
  -p, --password <pass>  Password (passed verbatim to the pool, e.g. "x" or "x;d=524288") [env:
                         PEAK_PASSWORD] [default: x]
  -w, --worker <name>    Worker name. A separate field, NOT an edit of -u: pools with a worker slot
                         get it there, single-string logins get ".<name>" appended. Ignored when -u
                         already carries a "." or "/" — one separator only, and the -u spelling
                         always wins [env: PEAK_WORKER]
  -c, --coin <name>      Coin / algorithm to mine, e.g. pearl or midstate (required) [env:
                         PEAK_COIN]

Mining:
  -d, --devices <list>  GPU device indices: all or comma-separated list [env: PEAK_DEVICES]
                        [default: all]

Behavior:
  -i, --status-interval <secs>
          Print status every N seconds [env: PEAK_STATUS_INTERVAL] [default: 60]
  -j, --job-timeout <secs>
          Force a reconnect if the pool pushes no new job for this many seconds. A live-but-wedged
          pool keeps the TCP alive (it answers our pings) while silently never sending a new job,
          leaving the GPU grinding a stale job whose shares all get rejected. Reconnecting makes the
          pool re-push a fresh job. Unset uses the coin's own default (180 s for Pearl and CSD); 0
          disables [env: PEAK_JOB_TIMEOUT]
  -n, --dry-run
          Mine without submitting proofs (dry run) [env: PEAK_DRY_RUN]
      --keepalive
          Send periodic mining.ping keepalives to the pool (every 20 s). Off by default — TCP-level
          keepalive already detects dead links, and some pools reject mining.ping. Enable for pools
          that close idle connections [env: PEAK_KEEPALIVE]
      --send-stales
          Submit shares even when the job rotated while the share was queued (stale). By default
          such shares are dropped (they'd only earn a "job not found" reject); enable to submit
          every share and let the pool be the sole judge (some pools still accept a just-rotated
          job). Applies to every coin [env: PEAK_SEND_STALES]
  -L, --legacy-auth
          Force standard Stratum V1 array-format authorize: ["user","password"]. Override only — by
          default the auth dialect is AUTO-DETECTED (named params {"wallet","worker","agent"} first,
          falling back to the array form on the first authorize failure, then locked). Pass this to
          pin the array form up front and skip detection (e.g. a pool that hangs instead of
          rejecting) [env: PEAK_LEGACY_AUTH]
      --dns-over-https [<on|off|strict>]
          Resolve pool hostnames over DNS-over-HTTPS instead of the system resolver. Bare flag = on.
          Use when an ISP hijacks/filters pool domains or the rig's own resolver is broken. `strict`
          disables the system-resolver fallback (needed to bypass a hijack, but then a pool name
          that only exists in /etc/hosts will NOT resolve). Off by default [env:
          PEAK_DNS_OVER_HTTPS] [default: off]
      --doh-url <url>
          DoH endpoint(s), tried in order; repeatable. Replaces the built-in list (Cloudflare,
          Google, Quad9 — all IP literals, so their certificates still verify and no bootstrap
          lookup is needed). Prefer an IP-literal URL: a hostname here is resolved by the very
          system resolver DoH exists to distrust [env: PEAK_DOH_URL]
      --proxy <socks5://[user:pass@]host:port>
          Route ALL outbound traffic through a SOCKS5 proxy: pool sessions (user and dev-fee), DoH
          lookups, the metrics push and the dev-fee manifest fetch. Use when the rig can only reach
          the pool through a jump host, or when the pool's IP is blocked. Credentials may ride in
          the URL (`socks5://user:pass@host:1080`, percent-escapes decoded) or come from
          --proxy-user/--proxy-pass, which win when both are given [env: PEAK_PROXY]
      --proxy-user <user>
          SOCKS5 proxy username. Overrides any username in --proxy — use it when the password
          contains characters that would break the URL [env: PEAK_PROXY_USER]
      --proxy-pass <pass>
          SOCKS5 proxy password. Overrides any password in --proxy. Prefer the env var: a password
          on the command line is visible in `ps` [env: PEAK_PROXY_PASS]
      --proxy-dns <remote|local>
          Who resolves pool hostnames when --proxy is set. `remote` (default) lets the PROXY
          resolve, so the name never reaches the local resolver and a pool that only exists on the
          proxy's side of the network still works. `local` resolves here (DoH if enabled, else the
          system resolver) and keeps multi-address failover, for a proxy whose transport you trust
          but whose resolver you don't [env: PEAK_PROXY_DNS] [default: remote]
  -a, --api-port <[host:]port>
          HTTP stats API listen address. A bare port binds 127.0.0.1 (localhost only); `host:port`
          binds that address — use `0.0.0.0:4068` (or `[::]:4068`) to reach it from Docker
          containers / the LAN. 0 = disabled. Default 4068  →  GET http://127.0.0.1:4068/summary
          [env: PEAK_API_PORT] [default: 4068]
      --report-stats
          Report rig telemetry to the pool via a periodic `mining.stats` push (total/per-GPU
          hashrate, uptime, GPU model/temp/power) for its dashboard. Sent over the EXISTING stratum
          connection to the pool you're mining — nowhere else. OFF by default: it's cosmetic (no
          effect on shares/payouts) and a pool that rejects unknown methods could drop the
          connection, so enable it only for pools that display these stats [env: PEAK_REPORT_STATS]

Logging:
  -l, --log-level <level>  Log level [env: PEAK_LOG_LEVEL] [default: info]
  -f, --log-file <path>    Also stream logs to this file (no ANSI colors) in addition to stderr. The
                           file is created if missing and TRUNCATED on start unless --log-append is
                           given [env: PEAK_LOG_FILE]
      --log-append         Append to --log-file instead of truncating it on start. Use to preserve
                           logs across restarts. No effect without --log-file [env: PEAK_LOG_APPEND]
      --no-tips            Suppress the periodic usage tips printed under the status table. Tips
                           only ever mention flags you are NOT already using, never repeat within a
                           run, and stop once the catalogue is exhausted — but a log scraper that
                           wants nothing but the table can turn them off here [env: PEAK_NO_TIPS]

GPU OC parameters:
      --gpu-core <MHz>         Core clock offset (MHz), applied to ALL GPUs. Per-GPU: --gpu-coreN,
                               e.g. --gpu-core0 150 sets only GPU 0 (N is the GPU index: --gpu-core1
                               → GPU 1, …)
      --gpu-core-delay <secs>  Delay core-offset application by this many seconds after mining
                               starts. Has no effect unless at least one selected GPU resolves a
                               --gpu-core/--gpu-coreN value. Zero preserves immediate startup
      --gpu-lcore <MHz>        Core clock lock (MHz), applied to ALL GPUs. Per-GPU: --gpu-lcoreN,
                               e.g. --gpu-lcore0 1800 locks only GPU 0
      --gpu-mem <MHz>          Memory clock offset (MHz), applied to ALL GPUs. Per-GPU: --gpu-memN,
                               e.g. --gpu-mem0 1200 sets only GPU 0
      --gpu-lmem <MHz>         Memory clock lock (MHz), applied to ALL GPUs. Per-GPU: --gpu-lmemN,
                               e.g. --gpu-lmem1 5001 locks only GPU 1
      --gpu-power <W|%>        Power limit: watts (e.g. 230) or percent of default (e.g. 80%),
                               applied to ALL GPUs. Per-GPU: --gpu-powerN, e.g. --gpu-power0 80%
                               caps only GPU 0
      --gpu-fan <%>            Fan speed (0–100%), held fixed, applied to ALL GPUs. Without
                               --gpu-fan-target it pins the fan; with it, it's the starting duty.
                               Per-GPU: --gpu-fanN, e.g. --gpu-fan0 70 sets only GPU 0
      --gpu-fan-target <°C>    Target temperature (°C) for closed-loop fan control, applied to ALL
                               GPUs: the fan steps ±3% every 10 s to hold this temp, within
                               --gpu-fan-min/max. Per-GPU: --gpu-fan-targetN, e.g. --gpu-fan-target0
                               65 for GPU 0
      --gpu-fan-min <%>        Minimum fan duty (0–100%) for closed-loop control (default 30),
                               applied to ALL GPUs. Per-GPU: --gpu-fan-minN, e.g. --gpu-fan-min0 40
                               for GPU 0
      --gpu-fan-max <%>        Maximum fan duty (0–100%) for closed-loop control (default 100),
                               applied to ALL GPUs. Per-GPU: --gpu-fan-maxN, e.g. --gpu-fan-max0 90
                               for GPU 0

GPU thermal parameters:
      --gpu-temp-stop <°C>   Pause a GPU when its temperature reaches this value (°C). The bare flag
                             applies to ALL GPUs; append the GPU index N to target one, e.g.
                             --gpu-temp-stop0 80 pauses only GPU 0 at 80°C (--gpu-temp-stop1 for GPU
                             1, and so on). When only this flag is given, --gpu-temp-start defaults
                             to stop-10
      --gpu-temp-start <°C>  Resume a paused GPU when its temperature drops to or below this value
                             (°C). Bare flag = all GPUs; per-GPU: --gpu-temp-startN, e.g.
                             --gpu-temp-start0 65 (must be strictly less than that GPU's stop)

OC bench:
      --oc-profile <SPEC>  Apply an overclock profile from the OC bench. Takes a mode name (eco,
                           balanced, max) or a profile id from https://oc.peakminer.org, which lists
                           the published profiles per card. Applies to every mined GPU; to set one
                           card use --oc-profile-gpuN, e.g. --oc-profile-gpu0 eco, which wins over
                           this one. Off when not given [env: PEAK_OC_PROFILE]
```

## Supported coins & dev fees

| Coin | Algorithm | Dev fee |
|---|---|---|
| Pearl (PRL) | pearlhash | 2% |
| CSD | SHA-256d | 2% |
| Midstate (MDS) | midstate | 2% |
| Alphanumeric (ALP) | alphanumeric | 2% |
| ParanO(1)d (NOID) | parano1d | **0%** solo · **3%** public pool |

NOID can be mined two ways — see [Mining ParanO(1)d](#mining-parano1d-noid). **Solo** against your own [peakpool](https://github.com/peakminer/peakpool) instance, where PeakMiner charges **nothing** and the pool build carries a 5% devfee; or on a **public NOID pool**, where PeakMiner charges **3%** and the pool sets its own terms.

New coins are added regularly — [follow announcements](https://t.me/peakminer_announcements).

## Supported GPUs

**NVIDIA** — all coins, Windows & Linux:

| Compute cap | Profile | Cards |
|---|---|---|
| sm_50 / sm_52 | maxwell | Tesla M40 / M60 / M4 / **GTX 900 series** / GTX 750 / 750 Ti / GTX TITAN X — CSD only |
| sm_60 / sm_61 | pascal | Tesla P100 / P40 / P4 / P104-100 / P106-100 / **GTX 10xx** — not for Pearl |
| sm_70 | volta | V100 / TITAN V — not for Pearl |
| sm_75 | turing | T4 / CMP 30HX / **RTX 20xx (optimized)** · GTX 16xx — not for Pearl |
| sm_80 / sm_86 | ampere | A100 / **CMP 170HX** (auto driver unlock — Pearl, Linux, needs root) / **RTX 30xx (optimized)** |
| sm_89 | ada | **RTX 40xx (optimized)** |
| sm_90 | hopper | **H100 / H200** |
| sm_100 | b200 | B200 / B300 |
| sm_120 | blackwell | **RTX 50xx (optimized)** |

**AMD** — CSD and Alphanumeric (ALP) only, Linux only:

| LLVM target | Architecture | Cards |
|---|---|---|
| gfx900 | Vega 10 | RX Vega 56 / 64 / Frontier Edition / Instinct MI25 |
| gfx906 | Vega 20 | Radeon VII / Pro VII / Instinct MI50 / MI60 |
| gfx908 | CDNA | Instinct MI100 |
| gfx90a | CDNA 2 | Instinct MI210 / MI250 / MI250X |
| gfx942 | CDNA 3 | Instinct MI300A / MI300X / MI325X |
| gfx950 | CDNA 4 | Instinct MI350X / MI355X |
| gfx1010 | RDNA 1 | RX 5700 XT / 5700 / 5600 XT |
| gfx1012 | RDNA 1 | RX 5500 XT / 5500 |
| gfx1030 | RDNA 2 | RX 6950 XT / 6900 XT / 6800 XT / 6800 |
| gfx1031 | RDNA 2 | RX 6750 XT / 6700 XT / 6700 |
| gfx1032 | RDNA 2 | RX 6650 XT / 6600 XT / 6600 |
| gfx1100 | RDNA 3 | **RX 7900 XTX / 7900 XT / 7900 GRE** |
| gfx1101 | RDNA 3 | RX 7800 XT / 7700 XT |
| gfx1102 | RDNA 3 | RX 7600 XT / 7600 |
| gfx1150 | RDNA 3.5 (APU) | Radeon 890M / 880M (Strix Point) |
| gfx1151 | RDNA 3.5 (APU) | Radeon 8060S / 8050S (Strix Halo / Ryzen AI Max) |
| gfx1200 | RDNA 4 | RX 9060 XT / 9060 |
| gfx1201 | RDNA 4 | **RX 9070 XT / 9070 GRE / 9070** |

**Pearl (PRL) requires RTX 20xx or newer.** Since v2.11.0 the Pearl network enforces rank-128 consensus rules, and the Maxwell / Pascal / Volta / GTX 16xx kernels cannot mine them — those cards keep working for CSD, Midstate and Alphanumeric.

**Requirements:** Windows or Linux, with an NVIDIA driver that supports the CUDA 12 runtime (the runtime is bundled — no toolkit install needed). For AMD cards (CSD and Alphanumeric, Linux): a recent `amdgpu` driver with ROCm support, plus the AMD runtime — install it once before mining:

```bash
curl -fsSL https://gist.githubusercontent.com/devpeakminer/9bfd2744a535a93a99ce1b078f778ff6/raw/be9732a5caed5d5c0a6a9614166d455e6e077506/install-csd-amd-runtime.sh | sudo bash
```

## Supported pools

PeakMiner works with any Stratum V1 pool. Tested and supported:

**Pearl (PRL)**

| Pool | Site |
|---|---|
| HeroMiners | [pearl.herominers.com](https://pearl.herominers.com) |
| LuckyPool | [pearl.luckypool.io](https://pearl.luckypool.io) |
| Kryptex | [pool.kryptex.com](https://pool.kryptex.com) — `prl.kryptex.network:7048` |
| unMineable | [unmineable.com](https://www.unmineable.com/?mode=advanced&algorithm=pearlpow) |
| AlphaPool | [pearl.alphapool.tech](https://pearl.alphapool.tech) |
| f2pool | [f2pool.com](https://www.f2pool.com) — `pearl.f2pool.com:5500`, add `--keepalive` |

**CSD**

| Pool | Site |
|---|---|
| LProute | [lproute.com](https://lproute.com) |
| Yamaduo | [pool.yamaduo.no](https://pool.yamaduo.no) |
| LuckyPool | [csd.luckypool.io](https://csd.luckypool.io) |

**Midstate (MDS)**

| Pool | Site |
|---|---|
| LProute | [lproute.com](https://lproute.com) — `eu.lproute.com:8960` |

**Alphanumeric (ALP)**

| Pool | Site |
|---|---|
| LProute | [lproute.com](https://lproute.com) — `sg.lproute.com:4260` |
| LuckyPool | [alp.luckypool.io](https://alp.luckypool.io) |

**ParanO(1)d (NOID)**

| Pool | Site |
|---|---|
| Any public NOID pool | its HTTP RPC endpoint, e.g. `https://<pool-host>/noid-rpc/` — miner fee **3%** |
| peakpool (self-hosted, solo) | [github.com/peakminer/peakpool](https://github.com/peakminer/peakpool/blob/main/deployments/parano1d/README.md) — `stratum+sv2://<your-host>:34254` — miner fee **0%** |

Use each pool's own host:port in your flight sheet's **Pool URL**. Comma-separate multiple URLs for failover.

## Quick start (HiveOS)

Create a flight sheet with a **Custom** miner and point the Installation URL at the release asset:

| Field | Value |
|---|---|
| Installation URL | `https://github.com/peakminer/peakminer/releases/download/v2.14.0/peakminer-2.14.0.tar.gz` |
| Miner | Custom → `peakminer` |
| Coin | `pearl` |
| Wallet | your Pearl address |
| Pool URL | `de.pearl.herominers.com:1200` (example) — **TLS/SSL is auto-detected** (no prefix needed); force it with `stratum+ssl://host:port`. Comma-separate multiple URLs for failover |
| Template | `%WAL%.%WORKER_NAME%` |
| Pass | optional (defaults to `x`) |

Apply the flight sheet — HiveOS downloads the package, installs it, and starts mining.

### Flight sheet as JSON

Ready-made flight sheets live in [`hiveos/`](hiveos/) — open the file, click **Raw**, copy the JSON,
then import it into HiveOS (Flight Sheets → import) and set your wallet:

- **Pearl (PRL)** → [`hiveos/pearl.json`](hiveos/pearl.json)
- **CSD** → [`hiveos/csd.json`](hiveos/csd.json)
- **Midstate (MDS)** → [`hiveos/midstate.json`](hiveos/midstate.json)
- **Alphanumeric (ALP)** → [`hiveos/alphanumeric.json`](hiveos/alphanumeric.json)
- **ParanO(1)d (NOID)** → [`hiveos/parano1d.json`](hiveos/parano1d.json) — set **Pool URL** to a public NOID pool's RPC URL, or to your own [peakpool](https://github.com/peakminer/peakpool) host

Update `install_url` in the JSON to the release you want.

### Extra miner config (optional)

The "Setup Miner Config" box accepts raw peakminer CLI flags, one per line or semicolon-separated:

```text
--devices 0,1          # mine on a GPU subset (default: all)
--legacy-auth          # standard Stratum V1 array authorize, for pools that need it
--job-timeout 60       # reconnect sooner when the pool stops sending new jobs
--api-port 4068        # stats API port (the stats script follows it automatically)
                       # use 0.0.0.0:4068 to expose it beyond localhost
```

The full flag list is in the [CLI reference](#cli-reference).

## Quick start (Windows)

1. Download **`peakminer-<version>-windows-x86_64.zip`** from the [Releases](../../releases) page and extract it.
2. Run from a terminal (PowerShell or CMD), or edit the included `start.bat`:

```bat
peakminer.exe --url de.pearl.herominers.com:1200 --user YOUR_WALLET.rig1
```

3. Leave the window open — it prints per-GPU hashrate, accepted shares, and temperatures.

**TLS/SSL is auto-detected** — just pass the pool's `host:port`; no `stratum+ssl://` prefix needed (you can still force it).

Example `start.bat`:

```bat
@echo off
peakminer.exe ^
  --url de.pearl.herominers.com:1200 ^
  --user YOUR_WALLET.rig1
pause
```

Common flags (full list in the [CLI reference](#cli-reference), or `peakminer.exe --help`):

```text
--url de.pearl.herominers.com:1200   # pool address (TLS/SSL auto-detected)
--user WALLET.WORKER   # your Pearl wallet + worker name
--devices 0,1          # mine on a GPU subset (default: all)
--api-port 4068        # built-in HTTP stats API (0.0.0.0:4068 to expose it on the LAN)
```

The CUDA 12 runtime ships inside the zip — no toolkit install needed, just a recent NVIDIA driver.

## Run with Docker

A [`Dockerfile`](Dockerfile) (Ubuntu 24.04) is included, and a **prebuilt image** is published on Docker Hub.

GPU access requires the host's NVIDIA driver plus the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (the `--gpus all` flag).

### Use the prebuilt image (no build needed)

```bash
docker pull peakminer/peakminer:2.14.0

# Run — -t shows the live miner output
docker run --rm -t --gpus all peakminer/peakminer:2.14.0 \
  --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER>
```

### Build it yourself

```bash
# Defaults to the latest version; override with --build-arg
docker build -t peakminer .
docker build -t peakminer:2.14.0 --build-arg PEAKMINER_VERSION=2.14.0 .

docker run --rm -t --gpus all peakminer \
  --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER>
```

Pass any miner flags after the image name. To reach the stats API from the host, publish the port
**and** bind the API to `0.0.0.0` — a bare `--api-port 4068` listens on the container's own
loopback, which `-p` cannot forward to:

```bash
docker run --rm -t --gpus all -p 4068:4068 peakminer/peakminer:2.14.0 \
  --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER> --api-port 0.0.0.0:4068
```

Then `curl 127.0.0.1:4068/summary` on the host. Only expose it on a trusted network — the API has
no authentication.

## Mining ParanO(1)d (NOID)

NOID can be mined two ways. Same binary, one flag apart — pick by what you would rather spend:
setup time, or fee.

| | Miner fee | What you run |
|---|---|---|
| **Public pool** | **3%** | nothing — point the miner at a pool and go |
| **Solo, your own pool** | **0%** | a full node + Stratum V2 pool, one `docker compose` |

### On a public pool

Point the miner at a NOID pool's HTTP RPC endpoint:

```bash
peakminer --coin parano1d \
  -o https://<pool-host>/noid-rpc/ \
  -u <your-o1-address>.rig0
```

Here `-u` is **your payout address** — the pool credits what you mine to it. Generate it on your own
machine with the official wallet and hand out only the public `o1…` address; mining never needs a
seed phrase or a wallet file. The `.rig0` suffix labels this machine in the pool's worker list.

PeakMiner charges **3%** on NOID mined this way. Whichever pool you choose sets its own terms
separately — read them on the pool's own page.

### Solo, against your own peakpool

Run your own **[peakpool](https://github.com/peakminer/peakpool)** — a parano1d full node and a
Stratum V2 solo pool in one `docker compose` — and every block your farm finds pays your wallet
directly out of the coinbase. No account, no balance held by anyone, no withdrawal.

Bring the stack up on a Linux box (see the
[setup guide](https://github.com/peakminer/peakpool/blob/main/deployments/parano1d/README.md)),
set your payout wallet in its `.env`, then point every rig at it:

```bash
peakminer --coin parano1d \
  -o stratum+sv2://<pool-host>:34254 \
  -u <your-o1-address>.rig1
```

- The pool speaks **Stratum V2 only**, on one Noise-encrypted port (`34254`). Use `127.0.0.1:34254`
  when the miner runs on the same machine as the pool, otherwise the pool host's LAN address.
- `-u` here is a **worker label, not a payout address** — the opposite of the public-pool case above.
  Blocks always pay the wallet configured in the pool. It still has to be a valid `o1…` address, so
  reuse your own; the `.rig1` suffix names the worker in the pool's status table.
- Difficulty auto-tunes per rig. There is nothing else to configure on the miner side.

Fees: **PeakMiner takes 0%** this way; the pool build carries a 5% devfee, printed as `devfee 5%`
in its banner on every start. That is the whole cost.

### HiveOS and Windows

On HiveOS, use the `parano1d` flight sheet in [`hiveos/`](hiveos/) and set **Pool URL** to the pool
you chose — a public pool's RPC URL, or your own peakpool host. On Windows, edit
`peakminer-parano1d.bat` from the release zip.

## Mining CSD / Midstate / Alphanumeric (CLI)

Set `--coin` and point at the matching pool (see [Supported pools](#supported-pools)):

```bash
# CSD
peakminer --coin csd -u WALLET[.WORKER] -o csd-ca.lproute.com:8760

# Midstate (MDS)
peakminer --coin midstate -u WALLET[.WORKER] -o eu.lproute.com:8960

# Alphanumeric (ALP)
peakminer --coin alphanumeric -u WALLET[.WORKER] -o sg.lproute.com:4260
```

Replace `WALLET[.WORKER]` with your coin address (worker optional). Same flags work on Windows
(`peakminer.exe …`) and Docker. TLS/SSL is auto-detected. Dev fee is **2%** on these coins (NOID is **0%** solo, **3%** on a public pool).

On Windows the zip ships a ready-made launcher per coin — `peakminer-csd.bat`,
`peakminer-midstate.bat` and `peakminer-alphanumeric.bat`: edit the wallet / worker / pool lines,
then double-click.

Mining CSD or Alphanumeric on an AMD card (Linux)? Install the AMD runtime first — see the one-line installer
under [Supported GPUs](#supported-gpus).

## Overclocking & temperature limits

PeakMiner can apply clock/power offsets, drive the fans (fixed duty or closed-loop on a target temperature), and protect cards with temperature limits — no external OC tool needed. **The bare flag applies to every GPU; append the GPU index `N` to target one card** (e.g. `--gpu-core0 150` tunes only GPU 0, `--gpu-mem1 1200` only GPU 1).

```text
--gpu-core <MHz>          Core clock offset (MHz).  Per-GPU: --gpu-coreN
--gpu-core-delay <secs>   Wait N seconds after mining starts before applying the core
                          offset. Only matters together with --gpu-core; 0 = apply at once
--gpu-lcore <MHz>         Core clock lock (MHz).    Per-GPU: --gpu-lcoreN
--gpu-mem <MHz>           Memory clock offset (MHz). Per-GPU: --gpu-memN
--gpu-lmem <MHz>          Memory clock lock (MHz).   Per-GPU: --gpu-lmemN
--gpu-power <W|%>         Power limit: watts (e.g. 230) or percent of default (e.g. 80%).
                          Per-GPU: --gpu-powerN
--gpu-fan <%>             Fan speed (0–100%), held fixed. With --gpu-fan-target it's the
                          starting duty instead. Per-GPU: --gpu-fanN
--gpu-fan-target <°C>     Closed-loop fan control: the fan steps ±3% every 10 s to hold this
                          temperature, within --gpu-fan-min / --gpu-fan-max (defaults 30/100).
                          Per-GPU: --gpu-fan-targetN
--gpu-temp-stop <°C>      Pause a GPU when its temperature reaches this value (°C).
                          Per-GPU: --gpu-temp-stopN. When only this flag is given,
                          --gpu-temp-start defaults to stop-10
--gpu-temp-start <°C>     Resume a paused GPU when its temperature drops to or below this
                          value (°C). Per-GPU: --gpu-temp-startN. Must be strictly less
                          than that GPU's stop
--oc-profile <SPEC>       Apply a measured overclock profile at startup: a mode name (eco,
                          balanced, max) or a profile id from https://oc.peakminer.org.
                          Per-GPU: --oc-profile-gpuN, which wins over the global one.
                          Off when not given
```

Example — core +150 MHz, memory +1200 MHz, 70% power, pause at 70 °C (resume at 60 °C):

```bash
peakminer --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER> \
  --gpu-core 150 --gpu-mem 1200 --gpu-power 70% --gpu-temp-stop 70
```

## Stats & logs

- Stats API (all platforms): `GET http://127.0.0.1:4068/summary` — hashrate reported in kH/s.
  Bound to localhost by default; pass `--api-port 0.0.0.0:4068` to reach it from another machine,
  a Docker host or a monitoring box (no authentication — keep it on a trusted network)
- Miner log (HiveOS): `/var/log/miner/custom/peakminer/peakminer.log`
- Generated command line (HiveOS): `/hive/miners/custom/peakminer/peakminer.conf`

## Troubleshooting

- **Mining stops right after adding `--proxy`** — that is by design: there is no fallback to a direct connection. Check the proxy is reachable from the rig (`curl --socks5 <host>:<port> https://example.com`), and try `--proxy-dns local` if the proxy cannot resolve your pool.
- **Stats API unreachable from another machine or from the Docker host** — by default it binds `127.0.0.1` inside the miner (or inside the container), so `-p` has nothing to forward. Start the miner with `--api-port 0.0.0.0:4068`.
- **Miner runs but dashboard stats are blank (HiveOS)** — run `curl 127.0.0.1:4068/summary` on the rig. If it answers, verify `/run/hive/MINER_RUN` exists (the HiveOS agent skips stats collection without it).
- **All shares rejected after a pool hiccup** — the built-in job watchdog (`--job-timeout`, default 180 s) reconnects automatically; lower it if your pool wedges often.
- **Connection keeps dropping on f2pool** — f2pool hangs up after ~20 s of silence. Add `--keepalive` so the miner pings it periodically.
- **Pool hostname will not resolve, or resolves to the wrong host** — some ISPs hijack or filter mining domains. Add `--dns-over-https on` (or `strict` to drop the system-resolver fallback entirely).
- **Rig hangs or the driver resets right after the miner starts with an overclock** — delay the core offset with `--gpu-core-delay 30` so the card is already under load when it lands.

## License

Proprietary — see [LICENSE](LICENSE). The release packages are free to download and use for mining; redistribution and reverse engineering are restricted per the license terms.
