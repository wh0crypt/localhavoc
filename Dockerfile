# ---- Stage 1: Compile ----
FROM golang:1.23-bookworm AS builder

RUN apt update && apt -y install \
    git \
    nasm \
    mingw-w64 \
    pkg-config \
    wget \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Manually install upx
RUN wget https://github.com/upx/upx/releases/download/v4.2.4/upx-4.2.4-amd64_linux.tar.xz \
    && tar -xf upx-4.2.4-amd64_linux.tar.xz \
    && mv upx-4.2.4-amd64_linux/upx /usr/local/bin/ \
    && rm -rf upx-4.2.4-amd64_linux*

WORKDIR /build
RUN git clone https://github.com/HavocFramework/Havoc.git .

# Patch strict go.mod and compile standalone
RUN cd teamserver/ \
    && chmod +x ./Install.sh \
    && ./Install.sh \
    && sed -i 's/go 1.21.0/go 1.23/' go.mod \
    && go build -v -o /build/havoc-ts main.go

# ---- Stage 2: Execute ----
FROM debian:bookworm-slim

RUN apt update && apt -y install \
    nasm \
    mingw-w64 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Import only compiled binary and data folder
COPY --from=builder /build/havoc-ts /app/havoc-ts
COPY --from=builder /build/data /app/data
COPY --from=builder /build/teamserver/pkg/handlers /app/teamserver/pkg/handlers
COPY --from=builder /build/payloads /app/payloads

EXPOSE 40056
