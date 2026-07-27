# PeakMiner — Pearl (PRL) Performance

Head-to-head against another popular miner on the **same GPU, same pool, back-to-back** —
rented single-GPU rigs on vast.ai at **default clocks (no manual OC)**.
Latest full sweep: **v2.4.1** (2026-07-28) — 23 GPUs, **0 invalid shares** on every card.

| GPU | Hashrate @ Power | vs other popular miners |
|---|---|---|
| GTX 1660 Ti | 1.3 TH/s @ 90 W | **+13.5%** |
| RTX 2060 | 24.4 TH/s @ 143 W | **+28.8%** |
| RTX 2060 SUPER | 39.0 TH/s @ 179 W | **+15.8%** |
| RTX 2080 SUPER | 48.0 TH/s @ 215 W | **+11.3%** |
| RTX 3060 | 47.0 TH/s @ 170 W | **+2.2%** |
| RTX 3060 Laptop | 47.6 TH/s @ 57 W | **+3.0%** |
| RTX 3060 Ti | 61.1 TH/s @ 199 W | **+2.4%** |
| RTX 3070 | 73.1 TH/s @ 220 W | **+2.7%** |
| RTX 3080 | 105.3 TH/s @ 289 W | **+4.6%** |
| RTX 3080 Ti | 129.0 TH/s @ 349 W | **+3.6%** |
| RTX 3090 | 121.4 TH/s @ 332 W | **+3.1%** |
| RTX 3090 Ti | 144.3 TH/s @ 449 W | **+4.5%** |
| RTX 4060 Ti | 86.0 TH/s @ 165 W | **+4.4%** |
| RTX 4070 | 113.6 TH/s @ 196 W | **+22.0%** |
| RTX 4070 Ti | 153.1 TH/s @ 284 W | **+4.7%** |
| RTX 4080 | 187.8 TH/s @ 319 W | **+6.5%** |
| RTX 4080 SUPER | 203.0 TH/s @ 319 W | **+6.1%** |
| RTX 4090 | 291.2 TH/s @ 449 W | **+3.0%** |
| RTX 5060 Ti | 91.7 TH/s @ 180 W | parity |
| RTX 5070 | 124.6 TH/s @ 250 W | parity |
| RTX 5070 Ti | 179.1 TH/s @ 300 W | parity |
| RTX 5080 | 215.2 TH/s @ 350 W | parity |
| RTX 5090 | 376.2 TH/s @ 575 W | parity |

PeakMiner **leads on the GTX 16, RTX 20, 30 and 40-series** at equal power, and runs at
**parity on the 50-series**. Figures are sustained averages at default OC — manual tuning
(`--gpu-core`, `--gpu-mem`, `--gpu-power`) typically yields more. Your numbers will vary with
GPU model, cooling, power limit, overclock, and pool.
