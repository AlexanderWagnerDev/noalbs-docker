FROM alexanderwagnerdev/alpine:builder AS builder

RUN apk update && \
    apk upgrade && \
    apk add --no-cache build-base musl-dev clang git rust cargo pkgconfig openssl-dev && \
    rm -rf /var/cache/apk/*

WORKDIR /app

RUN git clone --branch v2.14.1 --depth 1 https://github.com/NOALBS/nginx-obs-automatic-low-bitrate-switching.git && \
    cd nginx-obs-automatic-low-bitrate-switching && \
    cargo build --release

FROM alexanderwagnerdev/alpine:autoupdate-stable

RUN apk update && \
    apk upgrade && \
    rm -rf /var/cache/apk/*

WORKDIR /app

COPY --from=builder /app/nginx-obs-automatic-low-bitrate-switching/target/release/noalbs .
COPY .env .env
COPY config.json config.json

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
