# PeakMiner: Multi-Coin GPU Miner for NVIDIA & AMD

[![Latest release](https://img.shields.io/github/v/release/peakminer/peakminer)](https://github.com/peakminer/peakminer/releases)
[![GitHub downloads](https://img.shields.io/github/downloads/peakminer/peakminer/total?label=downloads&logo=github)](https://github.com/peakminer/peakminer/releases)
[![Docker pulls](https://img.shields.io/docker/pulls/peakminer/peakminer)](https://hub.docker.com/r/peakminer/peakminer)
[![License](https://img.shields.io/badge/license-proprietary-lightgrey)](LICENSE)
[![Telegram](https://img.shields.io/badge/Telegram-peakminer__official-26A5E4?logo=telegram&logoColor=white)](https://t.me/peakminer_official)
[![Discord](https://img.shields.io/badge/Discord-join-5865F2?logo=discord&logoColor=white)](https://discord.gg/d5gVybewQ9)
[![Announcements](https://img.shields.io/badge/Announcements-channel-26A5E4?logo=telegram&logoColor=white)](https://t.me/peakminer_announcements)

PeakMiner is a high-performance, multi-coin cryptocurrency GPU miner engineered for
maximum hashrate, low power draw, and low VRAM usage, with mining kernels tuned for each
NVIDIA and AMD GPU generation. Runs on Windows, Linux, HiveOS and Docker over
Stratum V1, with auto-detected TLS/SSL and pool failover.

> ⛏️ [See all supported coins, algorithms & dev fees →](#supported-coins--dev-fees)
> New coins are added regularly, so [follow announcements](https://t.me/peakminer_announcements).

This repository hosts the official release packages. Download the latest build from the [**Releases**](../../releases) page.

## Table of contents

- [Highlights](#highlights)
- [Try it in one command](#try-it-in-one-command)
- [Supported coins & dev fees](#supported-coins--dev-fees)
- [Supported pools](#supported-pools)
- [Quick start](#quick-start)
- [CLI reference](#cli-reference)
- [Overclocking & temperature limits](#overclocking--temperature-limits)
- [Mining schedule](#mining-schedule)
- [Stats & logs](#stats--logs)
- [Where the miner keeps its own files](#where-the-miner-keeps-its-own-files)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Highlights

- **Multi-coin**: mine **Pearl (PRL)**, **Quantus (QUAN)**, **BTX**, **CSD**, **Midstate (MDS)**, **Alphanumeric (ALP)** or **ParanO(1)d (NOID)** over Stratum V1, with **auto-detected TLS/SSL** and failover pools
- **ParanO(1)d (NOID), your way**: mine it on a **public pool** with nothing to set up (**2%** miner fee), or **solo** against your own node plus Stratum V2 pool from [peakpool](https://github.com/peakminer/peakpool), where every block your farm finds pays **your** wallet in full and the miner fee is **0%**
- **Luck & effort stats**: see the % of expected effort used to find each share, plus running luck
- **Kernels tuned per GPU generation**: best efficiency on RTX 50xx, 40xx, 30xx and 20xx (high hash, low watt, low VRAM), and AMD cards are supported on CSD, Alphanumeric and Quantus
- **Overclocking & thermal limits**: per-GPU core/memory clocks, power limit, and automatic temperature pause/resume
- **Windows, Linux & Docker**: standalone Windows build (`.zip`), a ready-to-go HiveOS package, and a prebuilt image (`peakminer/peakminer`)
- **Built-in HTTP stats API**: per-GPU hashrate, temperature, fan, shares, and uptime on the HiveOS dashboard. Since v2.20.0 it can also take an API key and accept control requests: pause a card, switch pool, change the overclock, reconfigure

## Try it in one command

One block per coin, and each one is a single command: it downloads the binary, makes it
executable and starts mining right away. Copy the block, paste it into a terminal, done. These
lines mine to our test wallets, so swap in your own address to keep the proceeds. On Windows,
grab the zip from [Releases](../../releases) and run `peakminer.exe` with the same `--coin` /
`-o` / `-u` flags.

**Pearl (PRL):**

```bash
wget -q https://github.com/peakminer/peakminer/releases/download/v2.20.5/peakminer-2.20.5-linux-x86_64 -O peakminer && \
chmod +x peakminer && \
./peakminer --coin pearl -o de.pearl.herominers.com:1200 \
  -u prl1p8z8xpum3f8hahwhtcqq5xsk7t3n39g9uefheapcgvcexy4gcg35sdl0kcl.test
```

**Quantus (QUAN):**

```bash
wget -q https://github.com/peakminer/peakminer/releases/download/v2.20.5/peakminer-2.20.5-linux-x86_64 -O peakminer && \
chmod +x peakminer && \
./peakminer --coin quantus -o stratum+tcp://qtc.kryptex.network:7049 \
  -u qznMoMtokC91War6x8jHTiSqNYxFUe6RxmLCG9QxWiyayRR9j.test
```

**BTX:**

```bash
wget -q https://github.com/peakminer/peakminer/releases/download/v2.20.5/peakminer-2.20.5-linux-x86_64 -O peakminer && \
chmod +x peakminer && \
./peakminer --coin btx -o stratum+ssl://btx-eu.lproute.com:8665 \
  -u <YOUR-BTX-ADDRESS>.test
```

**CSD:**

```bash
wget -q https://github.com/peakminer/peakminer/releases/download/v2.20.5/peakminer-2.20.5-linux-x86_64 -O peakminer && \
chmod +x peakminer && \
./peakminer --coin csd -o csd-ca.lproute.com:8760 \
  -u 0x288aaabf2169f644b7126d8efcf641a18843a70e.test
```

**Midstate (MDS):**

```bash
wget -q https://github.com/peakminer/peakminer/releases/download/v2.20.5/peakminer-2.20.5-linux-x86_64 -O peakminer && \
chmod +x peakminer && \
./peakminer --coin midstate -o eu.lproute.com:8960 \
  -u 3a665ea3b2371272b7462354211d891b3a9ce8d7316eb3c9a9ca1133e422eb1e8bc6643d.test
```

**Alphanumeric (ALP):**

```bash
wget -q https://github.com/peakminer/peakminer/releases/download/v2.20.5/peakminer-2.20.5-linux-x86_64 -O peakminer && \
chmod +x peakminer && \
./peakminer --coin alphanumeric -o sg.lproute.com:4260 \
  -u 573e560a3e1324b4413a5cbd983f3e668b22218d.test
```

**ParanO(1)d (NOID):**

```bash
wget -q https://github.com/peakminer/peakminer/releases/download/v2.20.5/peakminer-2.20.5-linux-x86_64 -O peakminer && \
chmod +x peakminer && \
./peakminer --coin parano1d -o stratum+ssl://eu2.innovlab.cc:19601 \
  -u <YOUR-O1-ADDRESS>.test
```

On a public NOID pool `-u` is your own `o1...` payout address and the miner fee is 2%. Solo against
your own pool it is 0% and `-u` is only a worker label.

## Supported coins & dev fees

| Coin | Algorithm | Dev fee |
|---|---|---|
| Pearl (PRL) | pearlhash | 2% |
| BTX | MatMul PoW | 2% |
| CSD | SHA-256d | 2% |
| Midstate (MDS) | midstate | 2% |
| Alphanumeric (ALP) | alphanumeric | 2% |
| ParanO(1)d (NOID) | parano1d | **0%** solo · **2%** public pool |
| Quantus (QUAN) | quantus | 2% |

NOID can be mined two ways. **Solo** against your own [peakpool](https://github.com/peakminer/peakpool) instance, where PeakMiner charges **nothing** and the pool build carries a 5% devfee; or on a **public NOID pool**, where PeakMiner charges **2%** and the pool sets its own terms.

New coins are added regularly, so [follow announcements](https://t.me/peakminer_announcements).

**Which cards:** **Pearl (PRL) needs RTX 20xx or newer.** Since v2.11.0 the Pearl network enforces rank-128 consensus rules that the older kernels cannot mine, and those cards keep working for the other coins. Best efficiency is on RTX 50xx, 40xx, 30xx and 20xx. The other coins also run on the GTX 10xx and GTX 16xx series and on Tesla, T4, A100, H100, H200 and B200 cards, and CSD additionally on the GTX 900 and GTX 750 series. CMP 40HX / 90HX / 170HX need `--cmp-unlock` on Pearl (Linux, root).

**AMD** runs CSD and Alphanumeric on Linux over ROCm (Radeon RX 5000, RX 6000, RX 7000 and RX 9000 series, Radeon VII, RX Vega 56 / 64 and Instinct MI cards), and Quantus on Windows and Linux over the AMD OpenCL runtime the display driver installs (RX 400, RX 500 and RX 5000 series). Mixed NVIDIA and AMD rigs run in one process, and a card whose runtime refuses the program is skipped while the rest keeps mining. For CSD and Alphanumeric on AMD Linux, install the runtime once:

```bash
curl -fsSL https://gist.githubusercontent.com/devpeakminer/9bfd2744a535a93a99ce1b078f778ff6/raw/be9732a5caed5d5c0a6a9614166d455e6e077506/install-csd-amd-runtime.sh | sudo bash
```

**Requirements:** Windows or Linux with an NVIDIA driver that supports the CUDA 12 runtime (the runtime is bundled, no toolkit install needed), plus the `amdgpu` driver for AMD cards.

## Supported pools

PeakMiner works with any Stratum V1 pool. Tested and supported:

**Pearl (PRL)**

| Pool | Site |
|---|---|
| HeroMiners | [pearl.herominers.com](https://pearl.herominers.com) |
| LuckyPool | [pearl.luckypool.io](https://pearl.luckypool.io) |
| Kryptex | [pool.kryptex.com](https://pool.kryptex.com), `prl.kryptex.network:7048` |
| unMineable | [unmineable.com](https://www.unmineable.com/?mode=advanced&algorithm=pearlpow) |
| AlphaPool | [pearl.alphapool.tech](https://pearl.alphapool.tech) |
| f2pool | [f2pool.com](https://www.f2pool.com), `pearl.f2pool.com:5500`, add `--keepalive` |

**BTX**

| Pool | Site |
|---|---|
| LuckyPool | [btx.luckypool.io](https://btx.luckypool.io), `stratum+ssl://btx-eu.lproute.com:8665` (also `btx-us-east`, `btx-us-west`, `btx-us-central`, `btx-us-ord`, `btx-sg`, `btx-hk`, `btx-id`, `btx-au`, `btx-pl`, `btx-ru`, `btx-br`) |

**CSD**

| Pool | Site |
|---|---|
| LProute | [lproute.com](https://lproute.com) |
| Yamaduo | [pool.yamaduo.no](https://pool.yamaduo.no) |
| LuckyPool | [csd.luckypool.io](https://csd.luckypool.io) |

**Midstate (MDS)**

| Pool | Site |
|---|---|
| LProute | [lproute.com](https://lproute.com), `eu.lproute.com:8960` |

**Alphanumeric (ALP)**

| Pool | Site |
|---|---|
| LProute | [lproute.com](https://lproute.com), `sg.lproute.com:4260` |
| LuckyPool | [alp.luckypool.io](https://alp.luckypool.io) |

**Quantus (QUAN)**

| Pool | Site |
|---|---|
| Kryptex | [pool.kryptex.com](https://pool.kryptex.com), `stratum+tcp://qtc.kryptex.network:7049` |
| QuanPool | [quanpool.com](https://quanpool.com), `quic-insecure://mine.quanpool.com:9834` |
| LuckyPool | [quantus.luckypool.io](https://quantus.luckypool.io), `eu.lproute.com:3361` |

Any other pool that speaks QUIC or stratum works too: use whatever endpoint yours documents.

**ParanO(1)d (NOID)**

| Pool | Site |
|---|---|
| InnovLab | [noid.innovlab.cc](https://noid.innovlab.cc), `stratum+ssl://eu2.innovlab.cc:19601` (also `eu`, `hk2`, `hk`, `us`, `us2`, `ru`, or `stratum.innovlab.cc`), miner fee **2%** |
| suprnova | [noid.suprnova.cc](https://noid.suprnova.cc), `stratum+tcp://noid.suprnova.cc:3340`, miner fee **2%** |
| Any other public NOID pool | stratum, or an HTTP RPC endpoint such as `https://<pool-host>/noid-rpc/`, miner fee **2%** |
| peakpool (self-hosted, solo) | [github.com/peakminer/peakpool](https://github.com/peakminer/peakpool/blob/main/deployments/parano1d/README.md), `stratum+sv2://<your-host>:34254`, miner fee **0%** |

Use each pool's own host:port in your flight sheet's **Pool URL**. Comma-separate multiple URLs for failover.

## Quick start

Every platform installs from the same release package, so pick the one you run:

### HiveOS

Create a flight sheet with a **Custom** miner and point the Installation URL at the release asset:

| Field | Value |
|---|---|
| Installation URL | `https://github.com/peakminer/peakminer/releases/download/v2.20.5/peakminer-2.20.5.tar.gz` |
| Miner | Custom → `peakminer` |
| Coin | `pearl` |
| Wallet | your Pearl address |
| Pool URL | `de.pearl.herominers.com:1200` (example), and **TLS/SSL is auto-detected** (no prefix needed); force it with `stratum+ssl://host:port`. Comma-separate multiple URLs for failover |
| Template | `%WAL%.%WORKER_NAME%` |
| Pass | optional (defaults to `x`) |

Apply the flight sheet, and HiveOS downloads the package, installs it, and starts mining.

#### Flight sheet as JSON

Ready-made flight sheets live in [`hiveos/`](hiveos/): open the file, click **Raw**, copy the JSON,
then import it into HiveOS (Flight Sheets → import) and set your wallet:

- **Pearl (PRL)** → [`hiveos/pearl.json`](hiveos/pearl.json)
- **BTX** → [`hiveos/btx.json`](hiveos/btx.json)
- **CSD** → [`hiveos/csd.json`](hiveos/csd.json)
- **Midstate (MDS)** → [`hiveos/midstate.json`](hiveos/midstate.json)
- **Alphanumeric (ALP)** → [`hiveos/alphanumeric.json`](hiveos/alphanumeric.json)
- **ParanO(1)d (NOID)** → [`hiveos/parano1d.json`](hiveos/parano1d.json): set **Pool URL** to a public NOID pool's RPC URL, or to your own [peakpool](https://github.com/peakminer/peakpool) host
- **Quantus (QUAN)** → [`hiveos/quantus.json`](hiveos/quantus.json)

Update `install_url` in the JSON to the release you want.

#### Extra miner config (optional)

The "Setup Miner Config" box accepts raw peakminer CLI flags, one per line or semicolon-separated:

```text
--devices 0,1          # mine on a GPU subset (default: all)
--devices 01:00.0      # or pin cards by PCI address, which survives renumbering
--legacy-auth          # standard Stratum V1 array authorize, for pools that need it
--job-timeout 60       # reconnect sooner when the pool stops sending new jobs
--api-port 4068        # stats API port (the stats script follows it automatically)
                       # use 0.0.0.0:4068 to expose it beyond localhost
--api-key SECRET       # lock the API: every route but GET /health then needs the key
--api-control pause    # allow control requests, off by default (needs --api-key)
```

The full flag list is in the [CLI reference](#cli-reference), and every flag verbatim from the binary is [here](#every-flag-straight-from-the-binary).

### mmpOS

The same `.tar.gz` is an mmpOS custom miner, so there is no separate download. Add a custom miner with the package URL above, and the mmpOS dashboard reports per-GPU hashrate and share counts.

Each platform reads only its own files out of the one package: mmpOS uses `mmp-launch.sh`, `mmp-stats.sh` and `mmp-external.conf`, HiveOS uses the `h-*` files, and each ignores the other's. mmpOS passes the coin as a ticker (`PRL`, `QTC`, `BTX`, `MDS`, `ALP`, `NOID`, `CSD`) and the launcher maps it to the right `--coin` name. Anything you put in the profile's extra arguments is passed through to the miner unchanged.

### Windows

1. Download **`peakminer-<version>-windows-x86_64.zip`** from the [Releases](../../releases) page and extract it.
2. Run from a terminal (PowerShell or CMD), or edit the included `start.bat`:

```bat
peakminer.exe --url de.pearl.herominers.com:1200 --user YOUR_WALLET.rig1
```

3. Leave the window open: it prints per-GPU hashrate, accepted shares, and temperatures.

**TLS/SSL is auto-detected**: just pass the pool's `host:port`; no `stratum+ssl://` prefix needed (you can still force it).

Example `start.bat`:

```bat
@echo off
peakminer.exe ^
  --url de.pearl.herominers.com:1200 ^
  --user YOUR_WALLET.rig1
pause
```

Common flags (full list in [Every flag, straight from the binary](#every-flag-straight-from-the-binary), or `peakminer.exe --help`):

```text
--url de.pearl.herominers.com:1200   # pool address (TLS/SSL auto-detected)
--user WALLET.WORKER   # your Pearl wallet + worker name
--devices 0,1          # mine on a GPU subset (default: all)
--devices 01:00.0      # or pin cards by PCI address, which survives renumbering
--api-port 4068        # built-in HTTP stats API (0.0.0.0:4068 to expose it on the LAN)
```

The CUDA 12 runtime ships inside the zip, no toolkit install needed, just a recent NVIDIA driver.

### Docker

A [`Dockerfile`](Dockerfile) (Ubuntu 24.04) is included, and a **prebuilt image** is published on Docker Hub.

GPU access requires the host's NVIDIA driver plus the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (the `--gpus all` flag).

#### Use the prebuilt image (no build needed)

```bash
docker pull peakminer/peakminer:2.20.5

# Run (-t shows the live miner output)
docker run --rm -t --gpus all peakminer/peakminer:2.20.5 \
  --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER>
```

#### Build it yourself

```bash
# Defaults to the latest version; override with --build-arg
docker build -t peakminer .
docker build -t peakminer:2.20.5 --build-arg PEAKMINER_VERSION=2.20.5 .

docker run --rm -t --gpus all peakminer \
  --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER>
```

Pass any miner flags after the image name. To reach the stats API from the host, publish the port
**and** bind the API to `0.0.0.0`: a bare `--api-port 4068` listens on the container's own
loopback, which `-p` cannot forward to:

```bash
docker run --rm -t --gpus all -p 4068:4068 peakminer/peakminer:2.20.5 \
  --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER> --api-port 0.0.0.0:4068
```

Then `curl 127.0.0.1:4068/summary` on the host. Published like that the API is reachable by
anything that can route to the host, so add `--api-key <secret>` unless the network is fully
trusted. See [Locking the API with a key](#locking-the-api-with-a-key).

## CLI reference

The flags you'll actually reach for:

| Flag | What it does |
|---|---|
| `-o, --url <url>` | Pool URL. **Repeat it for automatic failover**: the miner moves to the next pool on its own when one goes down. TLS/SSL auto-detected |
| `-u, --user <wallet>` | Pool login, **sent verbatim**: type exactly what your pool documents (`wallet`, `wallet.worker`, `wallet/worker`, …) |
| `-w, --worker <name>` | Worker name as a **separate field**. Ignored when `-u` already carries a `.` or `/` |
| `-c, --coin <name>` | Coin / algorithm: `pearl`, `quantus`, `btx`, `csd`, `midstate`, `alphanumeric` or `parano1d` (required) |
| `-d, --devices <list>` | GPU subset: indices (`0,1`) or PCI addresses (`01:00.0,03:00.0`), one form per list (default: all) |
| `-a, --api-port <[host:]port>` | HTTP stats API. A bare port binds localhost; `0.0.0.0:4068` exposes it to Docker / the LAN (default 4068, `0` disables) |
| `--api-key <secret>` | Lock the stats API: every route except `GET /health` then needs the key in an `X-API-Key` or `Authorization: Bearer` header. Unset leaves the API open (off by default) |
| `--api-control <levels>` | Allow write requests on the stats API: `pause`, `pool`, `config`, `oc`, or `all`. Requires `--api-key`. See [Stats & logs](#stats--logs) (off by default) |
| `--state-dir <dir>` | Where the miner keeps its own files, today the API overlay written by `PUT /config` (default: the working directory) |
| `-j, --job-timeout <secs>` | Reconnect if the pool pushes no new job for N seconds (default 180) |
| `-L, --legacy-auth` | Pin standard Stratum V1 array authorize (auto-detected by default) |
| `-f, --log-file <path>` | Also write logs to a file (`--log-append` to keep them across restarts) |
| `--no-color` | Plain text output: no colour codes in the log lines, the status table or the banner. The standard `NO_COLOR` environment variable does the same. `--log-file` is always plain text |
| `--dns-over-https <on\|off\|strict>` | Resolve pool hostnames over DoH, for ISPs that hijack/filter pool domains (default `off`) |
| `--proxy <socks5://…>` | Send **all** outbound traffic through a SOCKS5 proxy, no silent direct fallback |
| `--oc-profile <spec>` | Apply an overclock profile at startup: `eco`, `balanced`, `max`, or a profile id from [oc.peakminer.org](https://oc.peakminer.org). Per-GPU: `--oc-profile-gpu0 eco` (off by default) |
| `--cmp-unlock` | **Pearl, Linux, needs root.** Unlock compute performance on **CMP 40HX / 90HX / 170HX**. **Off by default**: it was automatic before v2.17.2, so add this flag if you relied on it. Takes an optional boolean (`--cmp-unlock=false` to disable explicitly) |
| `--schedule <windows>` | Hours a GPU is allowed to mine, e.g. `22:00-18:00`. Several windows with `/`, one value per GPU with `,`, or `--scheduleN` for one card. See [Mining schedule](#mining-schedule) (off by default) |
| `--timezone <offset>` | Fixed UTC offset for log timestamps and `--schedule` windows, e.g. `+07:00` (default `0`, meaning UTC). Named zones and daylight-saving rules are not supported |
| `--quantus-auth-token[-file] <v>` | **quantus only**, solo against your own node: the node's `miner-auth-token`. Not needed on a pool |
| `--quantus-tls-cert-sha256[-file] <v>` | **quantus only**, required by `quic://`: SHA-256 of the node's self-signed TLS certificate. Not needed on a pool |

Every flag also has a `PEAK_*` environment-variable equivalent (shown in the help text), handy
for Docker and scripts. Overclocking, fan and thermal flags are covered in
[Overclocking & temperature limits](#overclocking--temperature-limits).

### Picking which GPUs mine

`--devices` takes either GPU indices (`--devices 0,2`) or PCI bus addresses
(`--devices 01:00.0,0000:03:00.0`). A PCI address pins a card by its slot, so the selection
survives a reboot or a driver change that renumbers the indices. Indices behave exactly as
before. Use one form for the whole list: a list mixing an index and a PCI address is rejected,
since both can name the same card.

### Multiple pools & failover

Pass `-o` as many times as you like. The miner mines the first pool that answers and **fails over
to the next one on its own** when a pool goes down, nothing to enable:

```bash
peakminer --coin pearl -u <WALLET>.<WORKER> \
  -o de.pearl.herominers.com:1200 \
  -o pearl.luckypool.io:3360 \
  -o prl.kryptex.network:7048
```

With more than one pool configured you can also switch by hand while mining: press **`l`** for the
next pool, **`h`** for the previous one, in the miner console. (Needs an interactive console; under
HiveOS or a detached Docker container there is no keyboard attached, so failover does the work.)

The `PEAK_POOL` environment variable takes the same list, comma-separated.

### Mining through a SOCKS5 proxy

`--proxy` routes **every** outbound connection through the proxy: pool sessions, DNS lookups and
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

# separate flags, for passwords with characters that break a URL
--proxy socks5://proxyhost:1080 --proxy-user myuser --proxy-pass mypass

# environment variables (safest, nothing lands in the process list)
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

### Every flag, straight from the binary

Full `--help` output (v2.20.5):

```text
 ____            _    __  __ _
|  _ \ ___  __ _| | _|  \/  (_)_ __   ___ _ __
| |_) / _ \/ _` | |/ / |\/| | | '_ \ / _ \ '__|
|  __/  __/ (_| |   <| |  | | | | | |  __/ |
|_|   \___|\__,_|_|\_\_|  |_|_|_| |_|\___|_|
# high-performance GPU miner · v2.20.5
(c) 2026 PeakMiner — proprietary, all rights reserved; no reverse engineering / redistribution (see LICENSE). build=20261031-1ad237
Multi-algorithm Stratum V1 miner

Usage: peakminer [OPTIONS] --url <url> --user <wallet> --coin <name>

Options:
  -h, --help     Print help
  -V, --version  Print version

Connection:
  -o, --url <url>
          Pool URL. Repeatable for failover (tried in order). stratum+tcp://host:port or
          stratum+ssl://host:port (the PEAK_POOL env form takes a comma-separated list). With more
          than one pool, press 'l' / 'h' in the console to switch to the next / previous pool
          without restarting [env: PEAK_POOL]
  -u, --user <wallet>
          Pool login, sent VERBATIM — never split. Type exactly what your pool documents (bare
          address, wallet.worker, wallet/worker, wallet=diff...). Use --worker to fill the separate
          worker field instead [env: PEAK_WALLET]
  -p, --password <pass>
          Password (passed verbatim to the pool, e.g. "x" or "x;d=524288") [env: PEAK_PASSWORD]
          [default: x]
  -w, --worker <name>
          Worker name. A separate field, NOT an edit of -u: pools with a worker slot get it there,
          single-string logins get ".<name>" appended. Ignored when -u already carries a "." or "/"
          — one separator only, and the -u spelling always wins [env: PEAK_WORKER]
  -c, --coin <name>
          Coin / algorithm to mine, e.g. pearl or midstate (required) [env: PEAK_COIN]
      --quantus-auth-token <token>
          quantus only: the `Ready { token }` secret for a `quic://` node or pool endpoint. For a
          solo node it is the contents of the node's `miner-auth-token` file; a public pool reuses
          the field as `<payout-address>.<worker>`. Prefer --quantus-auth-token-file: a secret on
          the command line is visible in `ps`. Unset ⇒ the -u/-w login identity is sent, which is
          what a pool wants [env: PEAK_QUANTUS_AUTH_TOKEN]
      --quantus-auth-token-file <path>
          quantus only: read --quantus-auth-token from this file (trailing newline trimmed). This is
          the spelling to use for a solo node — point it straight at
          `<base-path>/chains/<chain>/miner-auth-token` [env: PEAK_QUANTUS_AUTH_TOKEN_FILE]
      --quantus-tls-cert-sha256 <hex>
          quantus only: SHA-256 of the node's self-signed TLS certificate, 64 hex characters.
          Required by `quic://` — the certificate has no CA to check it against, so pinning is the
          whole authentication. The node logs this value and writes it to `miner-tls-cert-sha256`
          [env: PEAK_QUANTUS_TLS_CERT_SHA256]
      --quantus-tls-cert-sha256-file <path>
          quantus only: read --quantus-tls-cert-sha256 from this file. Point it at the node's own
          `<base-path>/chains/<chain>/miner-tls-cert-sha256` [env:
          PEAK_QUANTUS_TLS_CERT_SHA256_FILE]

Mining:
  -d, --devices <list>  GPUs to mine: `all`, a list of indices (`0,2`), or a list of PCI addresses
                        (`01:00.0,0000:03:00.0`). One form per list — do not mix indices and PCI
                        addresses. PCI pins a card by its stable bus address, which indices don't
                        guarantee across reboots or driver changes [env: PEAK_DEVICES] [default:
                        all]

Behavior:
  -i, --status-interval <secs>
          Print status every N seconds [env: PEAK_STATUS_INTERVAL] [default: 60]
  -j, --job-timeout <secs>
          Force a reconnect if the pool pushes no new job for this many seconds. A live-but-wedged
          pool keeps the TCP alive (it answers our pings) while silently never sending a new job,
          leaving the GPU grinding a stale job whose shares all get rejected. Reconnecting makes the
          pool re-push a fresh job. Unset uses the coin's own default (180 s for Pearl and CSD); 0
          disables [env: PEAK_JOB_TIMEOUT]
      --timezone <offset>
          Fixed UTC offset for log timestamps and mining schedules. Use 0/UTC for UTC, or an offset
          such as +02:00 or -07:00. Named timezones and daylight-saving rules are not included [env:
          PEAK_TIMEZONE] [default: 0]
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
      --api-key <secret>
          Stats API key. When set, every API request (except GET /health) must carry `X-API-Key:
          <secret>` or `Authorization: Bearer <secret>`; a missing or wrong key gets 401. Unset
          keeps the API open, so set it before `-a 0.0.0.0:4068` exposes it to the LAN. An empty
          value counts as unset (docker-compose `${API_KEY:-}` idiom) [env: PEAK_API_KEY]
      --api-control <pause,pool,config,oc|all>
          Control endpoints on the stats API, OFF by default. `pause` adds POST
          /control/pause|resume (per-GPU API hold, ORed with thermal and --schedule); `pool` adds
          POST /control/pool (same as the l/h hotkeys); `config` adds PUT /config and DELETE
          /config/overlay (coin, pools, user, worker — written to the overlay file in --state-dir,
          then the miner restarts itself); `oc` reserves the clock/fan endpoints. Any level also
          adds GET /config and GET /control/state. `all` = every level. Requires --api-key and an
          enabled -a: the miner refuses to start with control on and no key — a write surface is
          never merely warned about [env: PEAK_API_CONTROL]
      --state-dir <dir>
          Directory for the files the miner keeps about itself — today the API overlay
          `peakminer.overlay.json` that PUT /config writes (mode 0600). Default: the working
          directory. In Docker point it at a mounted volume so a reconfiguration survives the
          container being recreated [env: PEAK_STATE_DIR]
      --report-stats
          Report rig telemetry to the pool via a periodic `mining.stats` push (total/per-GPU
          hashrate, uptime, GPU model/temp/power) for its dashboard. Sent over the EXISTING stratum
          connection to the pool you're mining — nowhere else. OFF by default: it's cosmetic (no
          effect on shares/payouts) and a pool that rejects unknown methods could drop the
          connection, so enable it only for pools that display these stats [env: PEAK_REPORT_STATS]
      --cmp-unlock [<CMP_UNLOCK>]
          pearl, Linux: unlock CMP HX (40HX / 90HX / 170HX) compute performance. Off by default.
          When set, the first root run provisions a patched NVIDIA open driver for the running
          kernel

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
      --no-color           Plain-text stderr: no ANSI colour codes in log lines, the status table or
                           the banner. For launchers and log viewers that show raw escape codes. The
                           standard NO_COLOR environment variable does the same. --log-file is
                           always plain text [env: PEAK_NO_COLOR]

GPU OC parameters:
      --gpu-core <MHz>         Core clock offset (MHz), applied to ALL GPUs. Per-GPU: --gpu-coreN,
                               e.g. --gpu-core0 150 sets only GPU 0 (N is the GPU index: --gpu-core1
                               → GPU 1, …). A comma list sets one value per GPU index: --gpu-core
                               100,,2000 sets GPU 0 and GPU 2 and leaves GPU 1 alone (an empty slot
                               is not 0). The same list form works for every --gpu-* OC and
                               temperature flag
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
                             1, and so on). Or one value per GPU index: --gpu-temp-stop 80,,75
                             (empty = unset). When only this flag is given, --gpu-temp-start
                             defaults to stop-10
      --gpu-temp-start <°C>  Resume a paused GPU when its temperature drops to or below this value
                             (°C). Bare flag = all GPUs; per-GPU: --gpu-temp-startN, e.g.
                             --gpu-temp-start0 65, or a list: --gpu-temp-start 70,,65 (must be
                             strictly less than that GPU's stop)

GPU schedule:
      --schedule <WINDOWS>  Windows in the fixed offset selected by --timezone (UTC by default),
                            e.g. --schedule "22:00-18:00" mines 22:00→18:00 and pauses 18:00–22:00.
                            Several windows per GPU with '/': "00:00-06:00/22:00-24:00". One value
                            per GPU index with ',': "00:00-06:00,,06:00-18:00" (empty slot = that
                            GPU runs 24/7). Per-GPU override: --scheduleN, e.g. --schedule0.
                            start>end wraps past midnight [env: PEAK_SCHEDULE]

OC bench:
      --oc-profile <SPEC>  Apply an overclock profile from the OC bench. Takes a mode name (eco,
                           balanced, max) or a profile id from https://oc.peakminer.org, which lists
                           the published profiles per card. Applies to every mined GPU; to set one
                           card use --oc-profile-gpuN, e.g. --oc-profile-gpu0 eco, which wins over
                           this one. Off when not given [env: PEAK_OC_PROFILE]
```

## Overclocking & temperature limits

PeakMiner can apply clock/power offsets, drive the fans (fixed duty or closed-loop on a target temperature), and protect cards with temperature limits, with no external OC tool needed. There are three ways to aim a setting at a card:

- **One value for every GPU:** `--gpu-core 150`.
- **One flag per card**, appending the GPU index `N`: `--gpu-core0 150` tunes only GPU 0, `--gpu-mem1 1200` only GPU 1.
- **One value per card in a single flag** (new in v2.17.7): a comma list that maps to GPU index. `--gpu-core 150,,100` gives GPU 0 +150 MHz and GPU 2 +100 MHz, and leaves GPU 1 untouched. An empty slot means leave that card alone, which is not the same as setting it to 0.

The comma list is accepted by every `--gpu-*` flag below.

```text
--gpu-core <MHz>          Core clock offset (MHz).  Per-GPU: --gpu-coreN
--gpu-core-delay <secs>   Wait N seconds after mining starts before applying the core
                          offset. Only matters together with --gpu-core; 0 = apply at once
--gpu-lcore <MHz>         Core clock lock (MHz).    Per-GPU: --gpu-lcoreN
--gpu-mem <MHz>           Memory clock offset (MHz). Per-GPU: --gpu-memN
--gpu-lmem <MHz>          Memory clock lock (MHz).   Per-GPU: --gpu-lmemN
--gpu-power <W|%>         Power limit: watts (e.g. 230) or percent of default (e.g. 80%).
                          Per-GPU: --gpu-powerN
--gpu-fan <%>             Fan speed (0-100%), held fixed. With --gpu-fan-target it's the
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

Example, core +150 MHz, memory +1200 MHz, 70% power, pause at 70 °C (resume at 60 °C), applied to every GPU:

```bash
peakminer --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER> \
  --gpu-core 150 --gpu-mem 1200 --gpu-power 70% --gpu-temp-stop 70
```

Same rig, but each card tuned separately and GPU 1 left on its stock settings:

```bash
peakminer --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER> \
  --gpu-core 150,,100 --gpu-mem 1200,,800 --gpu-power 70%,,80% --gpu-temp-stop 70,,65
```

## Mining schedule

`--schedule` sets the hours a GPU is allowed to mine, for rigs on a tariff where some hours cost more than the coin is worth. Outside its window a GPU sits idle, and once every GPU is paused the pool connection is closed until the next window opens.

```bash
--schedule "22:00-18:00"               # mine 22:00 to 18:00, paused 18:00 to 22:00
--schedule "00:00-06:00/22:00-24:00"   # two windows for the same GPU, separated by /
--schedule "00:00-06:00,,06:00-18:00"  # per GPU: GPU 0 and GPU 2 on their own hours
--schedule0 "00:00-06:00"              # or one flag per card, same as the OC flags
```

Times are read in the offset that `--timezone` sets, and the default is **UTC**. Give the rig its own clock with a fixed offset:

```bash
--timezone +07:00 --schedule "22:00-06:00"   # 22:00 to 06:00 local, not UTC
```

`--timezone` also moves the log timestamps. It takes an offset such as `+02:00` or `-07:00`, or `0` / `UTC`. **Named zones like `Asia/Bangkok` are not accepted and there are no daylight-saving rules**, so if your clocks shift twice a year, change the offset yourself.

Two more things to keep in mind:

- **A start later than its end wraps past midnight**, so `22:00-18:00` is 20 hours of mining, not 4.
- **In the comma list, an empty slot means that card mines 24/7.** This is the opposite of the OC flags above, where an empty slot means leave the card's setting alone.

## Stats & logs

- Stats API (all platforms): `GET http://127.0.0.1:4068/summary`, hashrate in hashes per second
  (the HiveOS and mmpOS stats scripts are what convert to kH/s for the dashboards).
  Bound to localhost by default; pass `--api-port 0.0.0.0:4068` to reach it from another machine,
  a Docker host or a monitoring box. With no `--api-key` it is open to anyone who can reach the
  port, so set a key before you expose it (see below)
- Every endpoint, request body and status code: [API.md](API.md)
- Miner log (HiveOS): `/var/log/miner/custom/peakminer/peakminer.log`
- Generated command line (HiveOS): `/hive/miners/custom/peakminer/peakminer.conf`

### Locking the API with a key

`--api-key <secret>` (or `PEAK_API_KEY`) closes the API. Every route except `GET /health` then
needs the secret in a header, either one:

```bash
curl -H 'X-API-Key: <secret>'            http://127.0.0.1:4068/summary
curl -H 'Authorization: Bearer <secret>' http://127.0.0.1:4068/summary
```

A missing or wrong key gets `401`. Put the key in a header, never in the URL, where it would end
up in proxy and shell logs. An empty value counts as unset, so the docker-compose
`${API_KEY:-}` idiom keeps working, and with no key at all the API behaves exactly as it did
before v2.20.0. Binding it off-host without a key logs a warning at startup.

`GET /health` stays open and unauthenticated, so an orchestrator probe does not need the secret:

```json
{"ok":true,"version":"2.20.5"}
```

### Control endpoints

`--api-control <levels>` (or `PEAK_API_CONTROL`) turns on write access: a comma separated list of
levels, or `all`. It needs `--api-key` and an enabled `-a`, and with a level on and no key the
miner refuses to start rather than serve an unauthenticated write surface. A level that is off
answers `404`.

| Level | What it adds |
|---|---|
| any level | `GET /config`, `GET /control/state` |
| `pause` | `POST /control/pause` and `/control/resume`, body `{"gpus":[1]}` or `{}` for every card |
| `pool` | `POST /control/pool`, body `{"index":1}` or `{"action":"next"}`, the same move as the `l` and `h` hotkeys |
| `config` | `PUT /config` for coin, pools, user and worker, plus `DELETE /config/overlay` to drop back to the flags |
| `oc` | `GET` / `PUT` / `PATCH` / `DELETE /control/oc/{gpu}` for core, memory, power limit and fan |

```bash
peakminer -c pearl -o stratum+tcp://pool:3333 -u <wallet> \
  -a 0.0.0.0:4068 --api-key <secret> --api-control pause,pool

# park GPU 1, then put it back to work
curl -X POST -H 'X-API-Key: <secret>' -H 'content-type: application/json' \
  -d '{"gpus":[1]}' http://127.0.0.1:4068/control/pause
curl -X POST -H 'X-API-Key: <secret>' -H 'content-type: application/json' \
  -d '{}' http://127.0.0.1:4068/control/resume
```

A parked card reports `status: "paused"` and `hashrate: 0` in `/summary`, and `GET /control/state`
names every reason currently holding it. That matters because an API resume will not restart a
card that a temperature limit or `--schedule` is holding as well. Overclock changes apply in
place. The `config` level cannot hot-swap a coin or a pool list, so it writes the overlay file and
the miner restarts itself: poll `/health` until the new process answers.

Every write is serialised, logged with the address that sent it, and debounced. A debounced write
gets `429` with `Retry-After` and changes nothing.

The per-endpoint reference, with every request body, the overlay format and the full list of
status codes, is in [API.md](API.md).

## Where the miner keeps its own files

`--state-dir <dir>` (or `PEAK_STATE_DIR`) is the directory for files the miner keeps about itself,
today just `peakminer.overlay.json`, the overlay `PUT /config` writes (mode 0600). It defaults to
the working directory. Under Docker point it at a mounted volume, or a reconfiguration is lost the
moment the container is recreated. `DELETE /config/overlay` removes the overlay and the miner goes
back to the flags it was started with.

## Troubleshooting

- **Mining stops right after adding `--proxy`**: that is by design. There is no fallback to a direct connection. Check the proxy is reachable from the rig (`curl --socks5 <host>:<port> https://example.com`), and try `--proxy-dns local` if the proxy cannot resolve your pool.
- **Stats API unreachable from another machine or from the Docker host**: by default it binds `127.0.0.1` inside the miner (or inside the container), so `-p` has nothing to forward. Start the miner with `--api-port 0.0.0.0:4068`.
- **Stats API answers `401`**: an `--api-key` is set, so every route except `GET /health` needs `X-API-Key: <secret>` or `Authorization: Bearer <secret>`. Check that a reverse proxy is not stripping the header, and that the key is not sitting in the URL instead.
- **A control request answers `404`**: that level is not in `--api-control`. An off level is a `404`, not a `403`. The one exception is `PUT /config`, which answers `405` when the `config` level is off, because `GET /config` keeps that path routed at every level.
- **A control request answers `429`**: writes are debounced. Wait the `Retry-After` seconds and send it again. Nothing changed.
- **Miner runs but dashboard stats are blank (HiveOS)**: run `curl 127.0.0.1:4068/summary` on the rig. If it answers, verify `/run/hive/MINER_RUN` exists (the HiveOS agent skips stats collection without it).
- **All shares rejected after a pool hiccup**: the built-in job watchdog (`--job-timeout`, default 180 s) reconnects automatically; lower it if your pool wedges often.
- **Connection keeps dropping on f2pool**: f2pool hangs up after ~20 s of silence. Add `--keepalive` so the miner pings it periodically.
- **Pool hostname will not resolve, or resolves to the wrong host**: some ISPs hijack or filter mining domains. Add `--dns-over-https on` (or `strict` to drop the system-resolver fallback entirely).
- **Rig hangs or the driver resets right after the miner starts with an overclock**: delay the core offset with `--gpu-core-delay 30` so the card is already under load when it lands.

## License

Proprietary: see [LICENSE](LICENSE). The release packages are free to download and use for mining; redistribution and reverse engineering are restricted per the license terms.
