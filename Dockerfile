FROM alexanderwagnerdev/alpine:builder AS builder

RUN apk update && \
    apk upgrade && \
    apk add --no-cache build-base musl-dev clang git cargo pkgconfig openssl-dev && \
    rm -rf /var/cache/apk/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly && \
    . $HOME/.cargo/env

WORKDIR /app

RUN git clone --branch v2.14.1 --depth 1 https://github.com/NOALBS/nginx-obs-automatic-low-bitrate-switching.git && \
    cd nginx-obs-automatic-low-bitrate-switching && \
    cargo +nightly build --release

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
