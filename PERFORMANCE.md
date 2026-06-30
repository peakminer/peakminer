# PeakMiner — Pearl Performance

Real, pool-accepted hashrate on **Pearl (pearlhash)**, measured live on LuckyPool.
Latest full sweep: **v1.0.12** — 20 GPUs across Ampere / Ada / Blackwell, **0 invalid shares** on every card.

> **How these were measured:** rented single-GPU instances on **vast.ai** (3080 Ti on a local rig),
> each card at its **default clocks (no manual OC)**. With manual overclocking — core/memory offsets
> and power tuning via `--gpu-core` / `--gpu-mem` / `--gpu-power` — you can get **higher hashrate**
> than the numbers below. Absolute TH/s also varies by host (silicon bin, cooling, clocks) and pool,
> so treat these as a ballpark, not a guarantee.

---

## Current performance (v1.0.12 · default OC)

### RTX 30-series — Ampere

| GPU | Hashrate | Power | Efficiency |
|---|---|---|---|
| RTX 3060 | 37.1 TH/s | 129 W | 287 GH/W |
| RTX 3060 Ti | 56.5 TH/s | 199 W | 285 GH/W |
| RTX 3070 | 64.5 TH/s | 164 W | 393 GH/W |
| RTX 3070 Ti | 85.4 TH/s | 308 W | 278 GH/W |
| RTX 3080 | 107.7 TH/s | 318 W | 339 GH/W |
| RTX 3080 Ti | 121.0 TH/s | 348 W | 348 GH/W |
| RTX 3090 | 126.5 TH/s | 388 W | 327 GH/W |
| RTX 3090 Ti | 139.5 TH/s | 445 W | 312 GH/W |

### RTX 40-series — Ada

| GPU | Hashrate | Power | Efficiency |
|---|---|---|---|
| RTX 4060 Ti | 82.2 TH/s | 164 W | 501 GH/W |
| RTX 4070 | 108.6 TH/s | 196 W | 554 GH/W |
| RTX 4070 Ti | 151.1 TH/s | 283 W | 535 GH/W |
| RTX 4080 | 179.1 TH/s | 318 W | 563 GH/W |
| RTX 4090 | 288.8 TH/s | 449 W | 643 GH/W |

### RTX 50-series — Blackwell

| GPU | Hashrate | Power | Efficiency |
|---|---|---|---|
| RTX 5060 | 73.5 TH/s | 145 W | 507 GH/W |
| RTX 5060 Ti | 89.8 TH/s | 179 W | 501 GH/W |
| RTX 5070 | 124.2 TH/s | 250 W | 497 GH/W |
| RTX 5070 Ti | 174.0 TH/s | 300 W | 581 GH/W |
| RTX 5080 | 206.1 TH/s | 359 W | 574 GH/W |
| RTX 5090 | 354.3 TH/s | 574 W | 617 GH/W |

---

## How we compare

Measured head-to-head on the **same GPU, same pool, back-to-back** (separate competitor test set):

| GPU | PeakMiner | Other popular miners | PeakMiner advantage |
|---|---|---|---|
| RTX 4070 Ti | **143.5 TH/s** | ~123 TH/s | **+16.7%** |
| RTX 2060 SUPER | **28.8 TH/s** | ~25.1 TH/s | **+14.7%** |
| RTX 5060 | **70.2 TH/s** | ~67.5 TH/s | **+4.0%** |
| RTX 4060 Ti | **79.8 TH/s** | ~77.4 TH/s | **+3.1%** |
| RTX 3060 | **41.6 TH/s** | ~40.5 TH/s | **+2.7%** |

PeakMiner is the **fastest Pearl miner** we've measured — leading across the 20-, 30-, 40-, and
50-series. Figures are sustained averages, not short-window peaks.

---

## Notes

- Identical-output verified — every share is mathematically correct and pool-accepted (0 rejects).
- Same single binary; no per-card configuration needed; works on Windows, Linux/HiveOS and Docker.
- Numbers above are at **default OC** — manual tuning typically yields more. PeakMiner also has
  built-in OC/temperature controls (`--gpu-core`, `--gpu-mem`, `--gpu-power`, `--gpu-temp-stop`).

*Latest sweep 2026-06-30 on LuckyPool Pearl (vast.ai, default clocks). Your numbers will vary with
GPU model, cooling, power limit, overclock, and pool.*
