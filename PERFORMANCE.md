# PeakMiner — Pearl Performance

Real, pool-accepted hashrate on **Pearl (pearlhash)**, measured live on LuckyPool.
Latest full sweep: **v2.3.0** (2026-07-24/25) — 23 GPUs across Turing / Ampere / Ada / Blackwell, **0 invalid shares** on every card.

> **How these were measured:** rented single-GPU instances on **vast.ai**, each card at its
> **default clocks (no manual OC)**. Each row is the **best full-power measurement** for that card
> across our sweeps — runs on power-capped hosts (operator-locked power limits) are excluded, so
> the numbers reflect what the silicon does at its board power limit. With manual overclocking —
> core/memory offsets and power tuning via `--gpu-core` / `--gpu-mem` / `--gpu-power` — you can get
> **higher hashrate** than the numbers below. Absolute TH/s also varies by host (silicon bin,
> cooling, clocks) and pool, so treat these as a ballpark, not a guarantee.

---

## Current performance (default OC, best full-power measurement per card)

### RTX 20-series — Turing

| GPU | Hashrate | Power | Efficiency |
|---|---|---|---|
| RTX 2060 | 26.1 TH/s | 142 W | 184 GH/W |
| RTX 2070 | 29.0 TH/s | 169 W | 172 GH/W |
| RTX 2080 Ti | 48.1 TH/s | 228 W | 211 GH/W |

### RTX 30-series — Ampere

| GPU | Hashrate | Power | Efficiency |
|---|---|---|---|
| RTX 3060 | 45.8 TH/s | 169 W | 271 GH/W |
| RTX 3060 Ti | 57.9 TH/s | 198 W | 292 GH/W |
| RTX 3070 | 76.7 TH/s | 269 W | 285 GH/W |
| RTX 3070 Ti | 85.4 TH/s | 308 W | 278 GH/W |
| RTX 3080 | 107.7 TH/s | 318 W | 339 GH/W |
| RTX 3080 Ti | 125.6 TH/s | 398 W | 316 GH/W |
| RTX 3090 | 126.5 TH/s | 388 W | 327 GH/W |
| RTX 3090 Ti | 141.7 TH/s | 449 W | 316 GH/W |

### RTX 40-series — Ada

| GPU | Hashrate | Power | Efficiency |
|---|---|---|---|
| RTX 4060¹ | 57.2 TH/s | — | — |
| RTX 4060 Ti | 85.3 TH/s | 164 W | 520 GH/W |
| RTX 4070 | 108.6 TH/s | 196 W | 554 GH/W |
| RTX 4070 Ti | 151.1 TH/s | 283 W | 535 GH/W |
| RTX 4080 | 180.8 TH/s | 319 W | 567 GH/W |
| RTX 4090 | 288.8 TH/s | 449 W | 643 GH/W |

### RTX 50-series — Blackwell

| GPU | Hashrate | Power | Efficiency |
|---|---|---|---|
| RTX 5060 | 73.6 TH/s | 145 W | 508 GH/W |
| RTX 5060 Ti | 91.1 TH/s | 180 W | 506 GH/W |
| RTX 5070 | 128.6 TH/s | 274 W | 469 GH/W |
| RTX 5070 Ti | 175.2 TH/s | 299 W | 586 GH/W |
| RTX 5080 | 215.0 TH/s | 349 W | 616 GH/W |
| RTX 5090 | 362.9 TH/s | 599 W | 606 GH/W |

¹ Host's NVML exposed no power reading.

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

*Latest sweep 2026-07-24/25 on LuckyPool Pearl (vast.ai, default clocks). Your numbers will vary
with GPU model, cooling, power limit, overclock, and pool.*
