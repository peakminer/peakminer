# PeakMiner — Pearl Performance

Real, pool-accepted hashrate on **Pearl (pearlhash)**, measured live on LuckyPool.
Latest full sweep: **v2.3.1** (2026-07-26) — 27 GPUs across Turing / Ampere / Ada / Blackwell, **0 invalid shares** on every card.

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
| RTX 2060 SUPER | 38.9 TH/s | 179 W | 217 GH/W |
| RTX 2070 | 37.2 TH/s | 167 W | 223 GH/W |
| RTX 2070 SUPER | 47.3 TH/s | 212 W | 223 GH/W |
| RTX 2080 SUPER | 46.3 TH/s | 183 W | 253 GH/W |
| RTX 2080 Ti | 63.4 TH/s | 233 W | 272 GH/W |

### RTX 30-series — Ampere

| GPU | Hashrate | Power | Efficiency |
|---|---|---|---|
| RTX 3060 | 45.8 TH/s | 169 W | 271 GH/W |
| RTX 3060 Ti | 58.3 TH/s | 199 W | 293 GH/W |
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
| RTX 4070 | 113.6 TH/s | 199 W | 571 GH/W |
| RTX 4070 SUPER | 139.6 TH/s | 219 W | 637 GH/W |
| RTX 4070 Ti | 153.3 TH/s | 284 W | 540 GH/W |
| RTX 4070 Ti SUPER | 153.5 TH/s | 255 W | 602 GH/W |
| RTX 4080 | 195.7 TH/s | 319 W | 614 GH/W |
| RTX 4080 SUPER | 196.8 TH/s | 320 W | 615 GH/W |
| RTX 4090 | 291.3 TH/s | 448 W | 650 GH/W |

### RTX 50-series — Blackwell

| GPU | Hashrate | Power | Efficiency |
|---|---|---|---|
| RTX 5060 | 73.6 TH/s | 145 W | 508 GH/W |
| RTX 5060 Ti | 91.8 TH/s | 180 W | 510 GH/W |
| RTX 5070 | 128.6 TH/s | 274 W | 469 GH/W |
| RTX 5070 Ti | 176.9 TH/s | 299 W | 592 GH/W |
| RTX 5080 | 215.0 TH/s | 349 W | 616 GH/W |
| RTX 5090 | 362.9 TH/s | 599 W | 606 GH/W |

¹ Host's NVML exposed no power reading.
² RTX 2060: rerun on the v2.3.1 Turing pipeline pending — omitted until it lands.

---

## How we compare

Measured head-to-head on the **same GPU, same pool, back-to-back** (v2.3.1 comparison run,
2026-07-26):

| GPU | PeakMiner | Other popular miners | PeakMiner advantage |
|---|---|---|---|
| RTX 2080 Ti | **63.4 TH/s** | ~51.8 TH/s | **+22.4%** |
| RTX 4070 | **113.6 TH/s** | ~93.2 TH/s | **+21.8%** |
| RTX 2060 SUPER | **38.9 TH/s** | ~33.5 TH/s | **+16.1%** |
| RTX 2070 | **37.2 TH/s** | ~32.2 TH/s | **+15.4%** |
| RTX 4070 Ti SUPER | **153.5 TH/s** | ~140.4 TH/s | **+9.3%** |
| RTX 4080 SUPER | **196.8 TH/s** | ~186.2 TH/s | **+5.7%** |
| RTX 4090 | **291.3 TH/s** | ~281.2 TH/s | **+3.6%** |

PeakMiner **leads on the 20- and 40-series** at equal power and runs at **parity on the 30- and
50-series**. Figures are sustained averages, not short-window peaks.

---

## Notes

- Identical-output verified — every share is mathematically correct and pool-accepted (0 rejects).
- Same single binary; no per-card configuration needed; works on Windows, Linux/HiveOS and Docker.
- Numbers above are at **default OC** — manual tuning typically yields more. PeakMiner also has
  built-in OC/temperature controls (`--gpu-core`, `--gpu-mem`, `--gpu-power`, `--gpu-temp-stop`).

*Latest sweep 2026-07-26 on LuckyPool Pearl (vast.ai, default clocks). Your numbers will vary
with GPU model, cooling, power limit, overclock, and pool.*
