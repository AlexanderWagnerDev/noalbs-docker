FROM alpine:latest AS builder

RUN apk update && apk upgrade && \
    apk add --no-cache build-base musl-dev clang git rust cargo pkgconfig openssl-dev

WORKDIR /app

RUN git clone --branch v2.13.1 --depth 1 https://github.com/NOALBS/nginx-obs-automatic-low-bitrate-switching.git && \
    cd nginx-obs-automatic-low-bitrate-switching && \
    cargo build --release

FROM alpine:latest

RUN apk update && apk upgrade && \
    apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /app/nginx-obs-automatic-low-bitrate-switching/target/release/noalbs

CMD ["./noalbs"]
