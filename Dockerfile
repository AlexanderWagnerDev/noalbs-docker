FROM alexanderwagnerdev/alpine:builder AS builder

RUN apk update && \
    apk upgrade && \
    apk add --no-cache build-base musl-dev git pkgconfig openssl-dev openssl-libs-static patchelf binutils rust cargo && \
    rm -rf /var/cache/apk/*

WORKDIR /app

RUN git clone --branch v2.15.0 --depth 1 https://github.com/NOALBS/nginx-obs-automatic-low-bitrate-switching.git && \
    cd nginx-obs-automatic-low-bitrate-switching && \
    CARGO_BUILD_JOBS=$(nproc) cargo build --release

FROM alexanderwagnerdev/alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache libgcc && \
    rm -rf /var/cache/apk/*

WORKDIR /app

COPY --from=builder /app/nginx-obs-automatic-low-bitrate-switching/target/release/noalbs .
COPY .env .env
COPY config.json config.json

CMD ["./noalbs"]
