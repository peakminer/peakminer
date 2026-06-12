# peakminer

High-performance NVIDIA GPU miner for **Pearl (PRL)** — built for high hashrate, low power draw, and low VRAM usage, with the best optimization on **RTX 50xx (Blackwell)** cards.

This repository hosts the official release packages. Download the latest build from the [**Releases**](../../releases) page.

## Links

- 💬 Telegram: [t.me/peakminer_official](https://t.me/peakminer_official)
- 📢 Announcements: [t.me/peakminer_announcements](https://t.me/peakminer_announcements)
- 🐙 GitHub: [github.com/peakminer/peakminer](https://github.com/peakminer/peakminer)

## Highlights

- **Pearl (PRL)** support over Stratum V1, with TLS and failover pools
- Tuned CUDA kernels per GPU generation — **best efficiency on RTX 50xx**: high hash, low watt, low VRAM
- **HiveOS** package out of the box (`peakminer-<version>-hiveos.tar.gz`), Linux-first
- Built-in HTTP stats API: per-GPU hashrate, temperature, fan, shares, and uptime on the HiveOS dashboard

## Dev fee

| Coin | Fee |
|---|---|
| Pearl (PRL) | 3% |

## Supported GPUs

| Compute cap | Profile | Cards |
|---|---|---|
| sm_70 | volta | V100 |
| sm_75 | turing | RTX 20xx / T4 / CMP 30HX |
| sm_80 / sm_86 | ampere | A100 / RTX 30xx |
| sm_89 | ada | RTX 40xx |
| sm_90 | h100 | H100 / H200 |
| sm_100 | b200 | B200 / B300 |
| sm_120 | blackwell | **RTX 50xx (recommended)** |

**Requirements:** Linux, NVIDIA driver with CUDA 12 runtime support.

## Quick start (HiveOS)

Create a flight sheet with a **Custom** miner and point the Installation URL at the release asset:

| Field | Value |
|---|---|
| Installation URL | `https://github.com/peakminer/peakminer/releases/download/v<version>/peakminer-<version>-hiveos.tar.gz` |
| Miner | Custom → `peakminer` |
| Coin | `pearl` |
| Wallet | your Pearl address |
| Pool URL | `host:port` (plain TCP) or `stratum+ssl://host:port` (TLS); comma-separate multiple URLs for failover |
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

## Stats & logs

- Stats API: `GET http://127.0.0.1:4068/summary` on the rig (hashrate reported in kH/s)
- Miner log: `/var/log/miner/custom/peakminer/peakminer.log`
- Generated command line: `/hive/miners/custom/peakminer/peakminer.conf`

## Troubleshooting

- **Miner runs but dashboard stats are blank** — run `curl 127.0.0.1:4068/summary` on the rig. If it answers, verify `/run/hive/MINER_RUN` exists (the HiveOS agent skips stats collection without it).
- **All shares rejected after a pool hiccup** — the built-in job watchdog (`--job-timeout`, default 180 s) reconnects automatically; lower it if your pool wedges often.

## Roadmap

- [x] Pearl (PRL) — NVIDIA, HiveOS / Linux
- [ ] More coins and algorithms
- [ ] More operating systems

## License

Proprietary — see [LICENSE](LICENSE). The release packages are free to download and use for mining; redistribution and reverse engineering are restricted per the license terms.
