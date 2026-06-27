# peakminer

High-performance NVIDIA GPU miner for **Pearl (PRL)** — built for high hashrate, low power draw, and low VRAM usage, with the best optimization on **RTX 50xx (Blackwell)**, **RTX 40xx (Ada)**, **RTX 30xx (Ampere)**, and **RTX 20xx (Turing)** cards.

This repository hosts the official release packages. Download the latest build from the [**Releases**](../../releases) page.

## Links

- 💬 Telegram: [t.me/peakminer_official](https://t.me/peakminer_official)
- 🎮 Discord: [discord.gg/d5gVybewQ9](https://discord.gg/d5gVybewQ9)
- 📢 Announcements: [t.me/peakminer_announcements](https://t.me/peakminer_announcements)
- 🐙 GitHub: [github.com/peakminer/peakminer](https://github.com/peakminer/peakminer)

## Highlights

- **Pearl (PRL)** support over Stratum V1, with **auto-detected TLS/SSL** and failover pools
- Tuned CUDA kernels per GPU generation — **best efficiency on RTX 50xx, 40xx, 30xx and 20xx**: high hash, low watt, low VRAM
- **Overclocking & thermal limits** — per-GPU core/memory clocks, power limit, and automatic temperature pause/resume
- **Windows, Linux & Docker** — standalone Windows build (`.zip`), a ready-to-go HiveOS package, and a prebuilt image (`peakminer/peakminer`)
- Built-in HTTP stats API: per-GPU hashrate, temperature, fan, shares, and uptime on the HiveOS dashboard

## Performance

Real, pool-accepted hashrate on **Pearl (pearlhash)** — measured live, not synthetic.
Figures are sustained 10-minute averages (what the pool actually credits).

**Generation-over-generation** — same card, same power:

| GPU | PeakMiner | vs previous | Efficiency |
|---|---|---|---|
| RTX 4070 Ti | **143.5 TH/s** | **+24% faster** | 505 GH/W |
| RTX 4060 Ti | **79.8 TH/s** | **+14% faster** | 488 GH/W |
| RTX 5060 | **70.2 TH/s** | **+3.2% faster** | 682 GH/W |

**Head-to-head vs other popular miners** — same GPU, same pool, back-to-back:

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
| Pearl (PRL) | 3% |

## Supported GPUs

| Compute cap | Profile | Cards |
|---|---|---|
| sm_70 | volta | V100 |
| sm_75 | turing | T4 / CMP 30HX / **RTX 20xx (optimized)** |
| sm_80 / sm_86 | ampere | A100 / **RTX 30xx (optimized)** |
| sm_89 | ada | **RTX 40xx (optimized)** |
| sm_90 | h100 | H100 / H200 |
| sm_100 | b200 | B200 / B300 |
| sm_120 | blackwell | **RTX 50xx (optimized)** |

**Requirements:** Windows or Linux, with an NVIDIA driver that supports the CUDA 12 runtime (the runtime is bundled — no toolkit install needed).

## Supported pools

PeakMiner works with any Stratum V1 Pearl (PRL) pool. Tested and supported:

| Pool | Site |
|---|---|
| HeroMiners | [pearl.herominers.com](https://pearl.herominers.com) |
| BaikalMine | [baikalmine.com](https://baikalmine.com) |
| LuckyPool | [pearl.luckypool.io](https://pearl.luckypool.io) |
| Kryptex | [pool.kryptex.com](https://pool.kryptex.com) |
| AlphaPool | [pearl.alphapool.tech](https://pearl.alphapool.tech) |

Use each pool's own host:port in your flight sheet's **Pool URL**. Comma-separate multiple URLs for failover.

## Quick start (HiveOS)

Create a flight sheet with a **Custom** miner and point the Installation URL at the release asset:

| Field | Value |
|---|---|
| Installation URL | `https://github.com/peakminer/peakminer/releases/download/v1.0.8/peakminer-1.0.8.tar.gz` |
| Miner | Custom → `peakminer` |
| Coin | `pearl` |
| Wallet | your Pearl address |
| Pool URL | `de.pearl.herominers.com:1200` (example) — **TLS/SSL is auto-detected** (no prefix needed); force it with `stratum+ssl://host:port`. Comma-separate multiple URLs for failover |
| Template | `%WAL%.%WORKER_NAME%` |
| Pass | optional (defaults to `x`) |

Apply the flight sheet — HiveOS downloads the package, installs it, and starts mining.

### Extra miner config (optional)

The "Setup Miner Config" box accepts raw peakminer CLI flags, one per line or semicolon-separated:

```text
--devices 0,1          # mine on a GPU subset (default: all)
--legacy-auth          # standard Stratum V1 array authorize, for pools that need it
--slice-secs 0.25      # fresher jobs at slightly higher CPU
--api-port 4068        # stats API port (the stats script follows it automatically)
```

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

Common flags (`peakminer.exe --help` for the full list):

```text
--url de.pearl.herominers.com:1200   # pool address (TLS/SSL auto-detected)
--user WALLET.WORKER   # your Pearl wallet + worker name
--devices 0,1          # mine on a GPU subset (default: all)
--api-port 4068        # built-in HTTP stats API
```

The CUDA 12 runtime ships inside the zip — no toolkit install needed, just a recent NVIDIA driver.

## Overclocking & temperature limits

PeakMiner can apply clock/power offsets and protect cards with temperature limits — no external OC tool needed. Apply a value to all GPUs, or override a single card with the `N` suffix (e.g. `--gpu-core0`, `--gpu-mem1`).

```text
--gpu-core <MHz>          Core clock offset (MHz). Override per GPU with --gpu-coreN
--gpu-lcore <MHz>         Core clock lock (MHz). Override per GPU with --gpu-lcoreN
--gpu-mem <MHz>           Memory clock offset (MHz). Override per GPU with --gpu-memN
--gpu-lmem <MHz>          Memory clock lock (MHz). Override per GPU with --gpu-lmemN
--gpu-power <W|%>         Power limit: watts (e.g. 230) or percent of default (e.g. 80%).
                          Override per GPU with --gpu-powerN
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

## Run with Docker

A [`Dockerfile`](Dockerfile) (Ubuntu 24.04) is included, and a **prebuilt image** is published on Docker Hub.

GPU access requires the host's NVIDIA driver plus the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (the `--gpus all` flag).

GPU access requires the host's NVIDIA driver plus the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (the `--gpus all` flag).

### Use the prebuilt image (no build needed)

```bash
docker pull peakminer/peakminer:1.0.8

# Run — -t shows the live miner output
docker run --rm -t --gpus all peakminer/peakminer:1.0.8 \
  --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER>
```

### Build it yourself

```bash
# Defaults to the latest version; override with --build-arg
docker build -t peakminer .
docker build -t peakminer:1.0.8 --build-arg PEAKMINER_VERSION=1.0.8 .

docker run --rm -t --gpus all peakminer \
  --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER>
```

Pass any miner flags after the image name. Map the stats API to the host with `-p`:

```bash
docker run --rm -t --gpus all -p 4068:4068 peakminer/peakminer:1.0.8 \
  --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER> --api-port 4068
```

## Stats & logs

- Stats API: `GET http://127.0.0.1:4068/summary` on the rig (hashrate reported in kH/s)
- Miner log: `/var/log/miner/custom/peakminer/peakminer.log`
- Generated command line: `/hive/miners/custom/peakminer/peakminer.conf`

## Troubleshooting

- **Miner runs but dashboard stats are blank** — run `curl 127.0.0.1:4068/summary` on the rig. If it answers, verify `/run/hive/MINER_RUN` exists (the HiveOS agent skips stats collection without it).
- **All shares rejected after a pool hiccup** — the built-in job watchdog (`--job-timeout`, default 180 s) reconnects automatically; lower it if your pool wedges often.

## Roadmap

- [x] Pearl (PRL) — NVIDIA, HiveOS / Linux
- [x] Windows support
- [x] Auto-detected TLS/SSL pools
- [x] Overclocking & temperature limits
- [x] Docker image
- [ ] More coins and algorithms
- [ ] macOS / more operating systems

## License

Proprietary — see [LICENSE](LICENSE). The release packages are free to download and use for mining; redistribution and reverse engineering are restricted per the license terms.
