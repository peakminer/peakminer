# PeakMiner

[![Latest release](https://img.shields.io/github/v/release/peakminer/peakminer)](https://github.com/peakminer/peakminer/releases)
[![Docker pulls](https://img.shields.io/docker/pulls/peakminer/peakminer)](https://hub.docker.com/r/peakminer/peakminer)
[![License](https://img.shields.io/badge/license-proprietary-lightgrey)](LICENSE)

High-performance GPU miner for **Pearl (PRL)**, **BTX** and **CSD** — built for high hashrate, low power draw, and low VRAM usage, with the best optimization on **RTX 50xx (Blackwell)**, **RTX 40xx (Ada)**, **RTX 30xx (Ampere)**, and **RTX 20xx (Turing)** cards, plus data-center **H100 / H200 (Hopper)**. **AMD GPUs are supported for CSD (Linux only)** — from **Vega** through **RDNA 4**, including **Instinct (CDNA)** accelerators.

This repository hosts the official release packages. Download the latest build from the [**Releases**](../../releases) page.

## Table of contents

- [Links](#links)
- [Highlights](#highlights)
- [CLI reference](#cli-reference)
- [Performance](#performance)
- [Dev fee](#dev-fee)
- [Supported GPUs](#supported-gpus)
- [Supported pools](#supported-pools)
- [Quick start (HiveOS)](#quick-start-hiveos)
- [Quick start (Windows)](#quick-start-windows)
- [Run with Docker](#run-with-docker)
- [Mining BTX / CSD (CLI)](#mining-btx--csd-cli)
- [Overclocking & temperature limits](#overclocking--temperature-limits)
- [Stats & logs](#stats--logs)
- [Troubleshooting](#troubleshooting)
- [Roadmap](#roadmap)
- [License](#license)

## Links

- 💬 Telegram: [t.me/peakminer_official](https://t.me/peakminer_official)
- 🎮 Discord: [discord.gg/d5gVybewQ9](https://discord.gg/d5gVybewQ9)
- 📢 Announcements: [t.me/peakminer_announcements](https://t.me/peakminer_announcements)
- 🐙 GitHub: [github.com/peakminer/peakminer](https://github.com/peakminer/peakminer)

## Highlights

- **Multi-coin** — mine **Pearl (PRL)**, **BTX** or **CSD** over Stratum V1, with **auto-detected TLS/SSL** and failover pools
- **Luck & effort stats** — see the % of expected effort used to find each share, plus running luck
- **Tuned CUDA kernels per GPU generation** — best efficiency on RTX 50xx, 40xx, 30xx and 20xx: high hash, low watt, low VRAM
- **Overclocking & thermal limits** — per-GPU core/memory clocks, power limit, and automatic temperature pause/resume
- **Windows, Linux & Docker** — standalone Windows build (`.zip`), a ready-to-go HiveOS package, and a prebuilt image (`peakminer/peakminer`)
- **Built-in HTTP stats API** — per-GPU hashrate, temperature, fan, shares, and uptime on the HiveOS dashboard

## CLI reference

**Copy-paste test runs** — one per coin, ready to go (they mine to our test wallets; swap in your
own wallet to keep the proceeds). On Windows use `peakminer.exe` with the same arguments:

```bash
# Pearl (PRL)
peakminer --coin pearl -o de.pearl.herominers.com:1200 -u prl1p8z8xpum3f8hahwhtcqq5xsk7t3n39g9uefheapcgvcexy4gcg35sdl0kcl.test

# BTX
peakminer --coin btx -o btx-sg.lproute.com:8660 -u btx1zpgn9fvv7xqhhq83n7cfv0cytr560gnpwthfgha95pvf73nppdlasz0vhy8.test

# CSD
peakminer --coin csd -o csd-ca.lproute.com:8760 -u 0x288aaabf2169f644b7126d8efcf641a18843a70e.test
```

The flags you'll actually reach for:

| Flag | What it does |
|---|---|
| `-o, --url <url>` | Pool URL, repeatable for failover (tried in order). TLS/SSL auto-detected |
| `-u, --user <wallet[.worker]>` | Wallet address, optional `.worker` suffix |
| `-c, --coin <name>` | Coin / algorithm: `pearl`, `btx` or `csd` (required) |
| `-d, --devices <list>` | GPU subset, e.g. `0,1` (default: all) |
| `-a, --api-port <port>` | HTTP stats API on localhost (default 4068, `0` disables) |
| `-j, --job-timeout <secs>` | Reconnect if the pool pushes no new job for N seconds (default 180) |
| `-L, --legacy-auth` | Pin standard Stratum V1 array authorize (auto-detected by default) |
| `-f, --log-file <path>` | Also write logs to a file (`--log-append` to keep them across restarts) |

Every flag also has a `PEAK_*` environment-variable equivalent (shown in the help text) — handy
for Docker and scripts. Overclocking, fan and thermal flags are covered in
[Overclocking & temperature limits](#overclocking--temperature-limits).

Full `--help` output (v2.3.0):

```text
 ____            _    __  __ _
|  _ \ ___  __ _| | _|  \/  (_)_ __   ___ _ __
| |_) / _ \/ _` | |/ / |\/| | | '_ \ / _ \ '__|
|  __/  __/ (_| |   <| |  | | | | | |  __/ |
|_|   \___|\__,_|_|\_\_|  |_|_|_| |_|\___|_|
# high-performance GPU miner · v2.3.0
(c) 2026 PeakMiner — proprietary, all rights reserved; no reverse engineering / redistribution (see LICENSE). build=20260725-e8e9cb
Multi-algorithm Stratum V1 miner

Usage: peakminer [OPTIONS] --url <url> --user <wallet[.worker]> --coin <name>

Options:
  -h, --help     Print help
  -V, --version  Print version

Connection:
  -o, --url <url>               Pool URL. Repeatable for failover (tried in order).
                                stratum+tcp://host:port or stratum+ssl://host:port (the PEAK_POOL
                                env form takes a comma-separated list) [env: PEAK_POOL]
  -u, --user <wallet[.worker]>  Wallet address with optional worker suffix: wallet[.worker] [env:
                                PEAK_WALLET]
  -p, --password <PASSWORD>     Password (passed verbatim to the pool, e.g. "x" or "x;d=524288")
                                [env: PEAK_PASSWORD] [default: x]
  -w, --worker <name>           Worker name (overrides suffix in -u) [env: PEAK_WORKER]
  -c, --coin <name>             Coin / algorithm to mine, e.g. pearl or btx (required) [env:
                                PEAK_COIN]

Mining:
  -d, --devices <list>  GPU device indices: all or comma-separated list [env: PEAK_DEVICES]
                        [default: all]

Behavior:
  -i, --status-interval <secs>  Print status every N seconds [env: PEAK_STATUS_INTERVAL] [default:
                                60]
  -j, --job-timeout <secs>      Force a reconnect if the pool pushes no new job for this many
                                seconds. A live-but-wedged pool keeps the TCP alive (it answers our
                                pings) while silently never sending a new job, leaving the GPU
                                grinding a stale job whose shares all get rejected. Reconnecting
                                makes the pool re-push a fresh job. Unset uses the coin's own
                                default (180 s for Pearl and BTX); 0 disables [env:
                                PEAK_JOB_TIMEOUT]
  -n, --dry-run                 Mine without submitting proofs (dry run) [env: PEAK_DRY_RUN]
      --keepalive               Send periodic mining.ping keepalives to the pool (every 30 s). Off
                                by default — TCP-level keepalive already detects dead links, and
                                some pools reject mining.ping. Enable for pools that close idle
                                connections [env: PEAK_KEEPALIVE]
      --send-stales             Submit shares even when the job rotated while the share was queued
                                (stale). By default such shares are dropped (they'd only earn a "job
                                not found" reject); enable to submit every share and let the pool be
                                the sole judge (some pools still accept a just-rotated job). Applies
                                to every coin [env: PEAK_SEND_STALES]
  -L, --legacy-auth             Force standard Stratum V1 array-format authorize:
                                ["user","password"]. Override only — by default the auth dialect is
                                AUTO-DETECTED (named params {"wallet","worker","agent"} first,
                                falling back to the array form on the first authorize failure, then
                                locked). Pass this to pin the array form up front and skip detection
                                (e.g. a pool that hangs instead of rejecting) [env:
                                PEAK_LEGACY_AUTH]
  -a, --api-port <port>         HTTP stats API port, bound to 127.0.0.1 (localhost only). 0 =
                                disabled. Default 4068  →  GET http://127.0.0.1:4068/summary [env:
                                PEAK_API_PORT] [default: 4068]
      --report-stats            Report rig telemetry to the pool via a periodic `mining.stats` push
                                (total/per-GPU hashrate, uptime, GPU model/temp/power) for its
                                dashboard. Sent over the EXISTING stratum connection to the pool
                                you're mining — nowhere else. OFF by default: it's cosmetic (no
                                effect on shares/payouts) and a pool that rejects unknown methods
                                could drop the connection, so enable it only for pools that display
                                these stats [env: PEAK_REPORT_STATS]

Logging:
  -l, --log-level <level>  Log level [env: PEAK_LOG_LEVEL] [default: info]
  -f, --log-file <path>    Also stream logs to this file (no ANSI colors) in addition to stderr. The
                           file is created if missing and TRUNCATED on start unless --log-append is
                           given [env: PEAK_LOG_FILE]
      --log-append         Append to --log-file instead of truncating it on start. Use to preserve
                           logs across restarts. No effect without --log-file [env: PEAK_LOG_APPEND]

GPU OC parameters:
      --gpu-core <MHz>       Core clock offset (MHz). Override per GPU with --gpu-coreN
      --gpu-lcore <MHz>      Core clock lock (MHz). Override per GPU with --gpu-lcoreN
      --gpu-mem <MHz>        Memory clock offset (MHz). Override per GPU with --gpu-memN
      --gpu-lmem <MHz>       Memory clock lock (MHz). Override per GPU with --gpu-lmemN
      --gpu-power <W|%>      Power limit: watts (e.g. 230) or percent of default (e.g. 80%).
                             Override per GPU with --gpu-powerN
      --gpu-fan <%>          Fan speed (0–100%), held fixed. Without --gpu-fan-target it pins the
                             fan; with it, it's the starting duty. Override per GPU with --gpu-fanN
      --gpu-fan-target <°C>  Target temperature (°C) for closed-loop fan control: the fan steps ±3%
                             every 10 s to hold this temp, within --gpu-fan-min/max. Override per
                             GPU with --gpu-fan-targetN
      --gpu-fan-min <%>      Minimum fan duty (0–100%) for closed-loop control (default 30).
                             Override per GPU with --gpu-fan-minN
      --gpu-fan-max <%>      Maximum fan duty (0–100%) for closed-loop control (default 100).
                             Override per GPU with --gpu-fan-maxN

GPU thermal parameters:
      --gpu-temp-stop <°C>   Pause a GPU when its temperature reaches this value (°C). Override per
                             GPU with --gpu-temp-stopN. When only this flag is given,
                             --gpu-temp-start defaults to stop-10
      --gpu-temp-start <°C>  Resume a paused GPU when its temperature drops to or below this value
                             (°C). Override per GPU with --gpu-temp-startN. Must be strictly less
                             than stop
```

## Performance

Real, pool-accepted hashrate on **Pearl (pearlhash)** — measured live, not synthetic.
Latest full sweep: **v2.3.0**, 23 GPUs, 0 invalid shares. Measured on vast.ai at **default OC**,
best full-power measurement per card (power-capped hosts excluded) — manual overclocking typically
yields more.

**Current hashrate (default OC, sample):**

| GPU | Hashrate | Efficiency |
|---|---|---|
| RTX 5090 | 362.9 TH/s | 606 GH/W |
| RTX 4090 | 288.8 TH/s | 643 GH/W |
| RTX 5080 | 215.0 TH/s | 616 GH/W |
| RTX 4080 | 180.8 TH/s | 567 GH/W |
| RTX 5070 Ti | 175.2 TH/s | 586 GH/W |
| RTX 4070 Ti | 151.1 TH/s | 535 GH/W |
| RTX 3090 Ti | 141.7 TH/s | 316 GH/W |

Full table for all measured cards (20/30/40/50-series): [**PERFORMANCE.md**](PERFORMANCE.md).

**Head-to-head vs other popular miners** — same GPU, same pool, back-to-back. These numbers come
from a dedicated comparison run (an earlier sweep), so they can differ slightly from the table above:

| GPU | PeakMiner | Other miners | Advantage |
|---|---|---|---|
| RTX 4070 Ti | **143.5 TH/s** | ~123 TH/s | **+16.7%** |
| RTX 2060 SUPER | **28.8 TH/s** | ~25.1 TH/s | **+14.7%** |
| RTX 5060 | **70.2 TH/s** | ~67.5 TH/s | **+4.0%** |
| RTX 4060 Ti | **79.8 TH/s** | ~77.4 TH/s | **+3.1%** |
| RTX 3060 | **41.6 TH/s** | ~40.5 TH/s | **+2.7%** |

The fastest Pearl miner we've measured, leading across the 20-, 30-, 40-, and 50-series.
Full methodology: [**PERFORMANCE.md**](PERFORMANCE.md).

## Dev fee

| Coin | Fee |
|---|---|
| Pearl (PRL) | 2% |
| BTX | 3% |
| CSD | 3% |

## Supported GPUs

**NVIDIA** — all coins, Windows & Linux:

| Compute cap | Profile | Cards |
|---|---|---|
| sm_50 / sm_52 | maxwell | Tesla M40 / M60 / M4 / **GTX 900 series** / GTX 750 / 750 Ti / GTX TITAN X — CSD only |
| sm_60 / sm_61 | pascal | Tesla P100 / P40 / P4 / P104-100 / P106-100 / **GTX 10xx** — Pearl + CSD |
| sm_70 | volta | V100 |
| sm_75 | turing | T4 / CMP 30HX / **RTX 20xx (optimized)** |
| sm_80 / sm_86 | ampere | A100 / **CMP 170HX** (auto driver unlock — Pearl, Linux, needs root) / **RTX 30xx (optimized)** |
| sm_89 | ada | **RTX 40xx (optimized)** |
| sm_90 | hopper | **H100 / H200** |
| sm_100 | b200 | B200 / B300 |
| sm_120 | blackwell | **RTX 50xx (optimized)** |

**AMD** — CSD only, Linux only:

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

**Requirements:** Windows or Linux, with an NVIDIA driver that supports the CUDA 12 runtime (the runtime is bundled — no toolkit install needed). For AMD cards (CSD, Linux): a recent `amdgpu` driver with ROCm support, plus the AMD runtime — install it once before mining:

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
| Kryptex | [pool.kryptex.com](https://pool.kryptex.com) |
| unMineable | [unmineable.com](https://www.unmineable.com/?mode=advanced&algorithm=pearlpow) |
| AlphaPool | [pearl.alphapool.tech](https://pearl.alphapool.tech) |

**BTX**

| Pool | Site |
|---|---|
| LProute | [lproute.com](https://lproute.com) |
| NinjaRaider | [ninjaraider.com/btx-pplns](https://ninjaraider.com/btx-pplns) |
| LuckyPool | [btx.luckypool.io](https://btx.luckypool.io) |

**CSD**

| Pool | Site |
|---|---|
| LProute | [lproute.com](https://lproute.com) |
| Yamaduo | [pool.yamaduo.no](https://pool.yamaduo.no) |
| LuckyPool | [csd.luckypool.io](https://csd.luckypool.io) |

Use each pool's own host:port in your flight sheet's **Pool URL**. Comma-separate multiple URLs for failover.

## Quick start (HiveOS)

Create a flight sheet with a **Custom** miner and point the Installation URL at the release asset:

| Field | Value |
|---|---|
| Installation URL | `https://github.com/peakminer/peakminer/releases/download/v2.3.0/peakminer-2.3.0.tar.gz` |
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
- **BTX** → [`hiveos/btx.json`](hiveos/btx.json)
- **CSD** → [`hiveos/csd.json`](hiveos/csd.json)

Update `install_url` in the JSON to the release you want.

### Extra miner config (optional)

The "Setup Miner Config" box accepts raw peakminer CLI flags, one per line or semicolon-separated:

```text
--devices 0,1          # mine on a GPU subset (default: all)
--legacy-auth          # standard Stratum V1 array authorize, for pools that need it
--job-timeout 60       # reconnect sooner when the pool stops sending new jobs
--api-port 4068        # stats API port (the stats script follows it automatically)
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
--api-port 4068        # built-in HTTP stats API
```

The CUDA 12 runtime ships inside the zip — no toolkit install needed, just a recent NVIDIA driver.

## Run with Docker

A [`Dockerfile`](Dockerfile) (Ubuntu 24.04) is included, and a **prebuilt image** is published on Docker Hub.

GPU access requires the host's NVIDIA driver plus the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (the `--gpus all` flag).

### Use the prebuilt image (no build needed)

```bash
docker pull peakminer/peakminer:2.3.0

# Run — -t shows the live miner output
docker run --rm -t --gpus all peakminer/peakminer:2.3.0 \
  --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER>
```

### Build it yourself

```bash
# Defaults to the latest version; override with --build-arg
docker build -t peakminer .
docker build -t peakminer:2.3.0 --build-arg PEAKMINER_VERSION=2.3.0 .

docker run --rm -t --gpus all peakminer \
  --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER>
```

Pass any miner flags after the image name. Map the stats API to the host with `-p`:

```bash
docker run --rm -t --gpus all -p 4068:4068 peakminer/peakminer:2.3.0 \
  --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER> --api-port 4068
```

## Mining BTX / CSD (CLI)

Set `--coin` and point at the matching pool (see [Supported pools](#supported-pools)):

```bash
# BTX
peakminer --coin btx -u WALLET[.WORKER] -o btx-sg.lproute.com:8660

# CSD
peakminer --coin csd -u WALLET[.WORKER] -o csd-ca.lproute.com:8760
```

Replace `WALLET[.WORKER]` with your coin address (worker optional). Same flags work on Windows
(`peakminer.exe …`) and Docker. TLS/SSL is auto-detected; **3% dev fee**.

Mining CSD on an AMD card (Linux)? Install the AMD runtime first — see the one-line installer
under [Supported GPUs](#supported-gpus).

## Overclocking & temperature limits

PeakMiner can apply clock/power offsets, drive the fans (fixed duty or closed-loop on a target temperature), and protect cards with temperature limits — no external OC tool needed. Apply a value to all GPUs, or override a single card with the `N` suffix (e.g. `--gpu-core0`, `--gpu-mem1`).

```text
--gpu-core <MHz>          Core clock offset (MHz). Override per GPU with --gpu-coreN
--gpu-lcore <MHz>         Core clock lock (MHz). Override per GPU with --gpu-lcoreN
--gpu-mem <MHz>           Memory clock offset (MHz). Override per GPU with --gpu-memN
--gpu-lmem <MHz>          Memory clock lock (MHz). Override per GPU with --gpu-lmemN
--gpu-power <W|%>         Power limit: watts (e.g. 230) or percent of default (e.g. 80%).
                          Override per GPU with --gpu-powerN
--gpu-fan <%>             Fan speed (0–100%), held fixed. With --gpu-fan-target it's the
                          starting duty instead. Override per GPU with --gpu-fanN
--gpu-fan-target <°C>     Closed-loop fan control: the fan steps ±3% every 10 s to hold this
                          temperature, within --gpu-fan-min / --gpu-fan-max (defaults 30/100).
                          Override per GPU with --gpu-fan-targetN
--gpu-temp-stop <°C>      Pause a GPU when its temperature reaches this value (°C). Override
                          per GPU with --gpu-temp-stopN. When only this flag is given,
                          --gpu-temp-start defaults to stop-10
--gpu-temp-start <°C>     Resume a paused GPU when its temperature drops to or below this
                          value (°C). Override per GPU with --gpu-temp-startN. Must be
                          strictly less than stop
```

Example — core +150 MHz, memory +1200 MHz, 70% power, pause at 70 °C (resume at 60 °C):

```bash
peakminer --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER> \
  --gpu-core 150 --gpu-mem 1200 --gpu-power 70% --gpu-temp-stop 70
```

## Stats & logs

- Stats API (all platforms): `GET http://127.0.0.1:4068/summary` — hashrate reported in kH/s
- Miner log (HiveOS): `/var/log/miner/custom/peakminer/peakminer.log`
- Generated command line (HiveOS): `/hive/miners/custom/peakminer/peakminer.conf`

## Troubleshooting

- **Miner runs but dashboard stats are blank (HiveOS)** — run `curl 127.0.0.1:4068/summary` on the rig. If it answers, verify `/run/hive/MINER_RUN` exists (the HiveOS agent skips stats collection without it).
- **All shares rejected after a pool hiccup** — the built-in job watchdog (`--job-timeout`, default 180 s) reconnects automatically; lower it if your pool wedges often.

## Roadmap

- [x] Pearl (PRL) — NVIDIA, HiveOS / Linux
- [x] Windows support
- [x] Auto-detected TLS/SSL pools
- [x] Overclocking & temperature limits
- [x] Docker image
- [x] AMD GPU support for CSD (Linux)
- [ ] More coins and algorithms
- [ ] macOS / more operating systems

## License

Proprietary — see [LICENSE](LICENSE). The release packages are free to download and use for mining; redistribution and reverse engineering are restricted per the license terms.
