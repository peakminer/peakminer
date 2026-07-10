# PeakMiner — NVIDIA GPU miner for Pearl (PRL)
# Ubuntu 24.04 base; the binary is downloaded from the GitHub release.
#
# Build:
#   docker build -t peakminer .
#   docker build -t peakminer:1.0.17 --build-arg PEAKMINER_VERSION=1.0.17 .
#
# Run (needs the NVIDIA Container Toolkit on the host):
#   docker run --rm --gpus all peakminer \
#     --url de.pearl.herominers.com:1200 --user <WALLET>.<WORKER>

FROM ubuntu:24.04

# Version of PeakMiner to pull from GitHub Releases.
ARG PEAKMINER_VERSION=1.0.17
ARG RELEASE_URL=https://github.com/peakminer/peakminer/releases/download/v${PEAKMINER_VERSION}/peakminer-${PEAKMINER_VERSION}-linux-x86_64

# ca-certificates: TLS/SSL pool connections. curl: fetch the release binary.
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/peakminer

# Download the standalone Linux binary.
RUN curl -fSL "${RELEASE_URL}" -o /opt/peakminer/peakminer \
 && chmod +x /opt/peakminer/peakminer

ENV PATH="/opt/peakminer:${PATH}"

# Pass miner flags as `docker run` arguments.
ENTRYPOINT ["peakminer"]
