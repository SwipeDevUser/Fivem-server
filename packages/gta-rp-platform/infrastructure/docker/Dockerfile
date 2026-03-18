# FiveM Server Dockerfile
FROM ubuntu:22.04

WORKDIR /fivem

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    git \
    curl \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Download FiveM Server binary (Linux)
RUN cd /tmp && \
    wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master -O fx.zip && \
    unzip -q fx.zip -d /fivem && \
    rm fx.zip

# Copy server files
COPY server/server.cfg /fivem/server.cfg
COPY server/resources /fivem/resources

# Create data directories
RUN mkdir -p /fivem/data /fivem/logs

# Expose ports
EXPOSE 30120 30120/udp

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:30120/player || exit 1

# Run FiveM server
CMD ["/fivem/FXServer", "+set", "citizen_dir", "/fivem/citizen", "+set", "sv_dataPath", "/fivem/data/"]
