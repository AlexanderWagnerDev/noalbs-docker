FROM alexanderwagnerdev/alpine:builder AS rust-builder

RUN apk add --no-cache \
    build-base \
    cmake \
    curl \
    git \
    python3 \
    openssl-dev \
    zlib-dev \
    libffi-dev \
    ninja \
    llvm-dev \
    clang

WORKDIR /rust

RUN git clone --depth 1 --branch master https://github.com/rust-lang/rust.git . && \
    git submodule update --init --recursive --depth 1

RUN cat > config.toml <<EOF
[llvm]
link-shared = true

[build]
target = ["$(uname -m)-unknown-linux-musl"]
extended = true
tools = ["cargo", "rustfmt"]
sanitizers = false
profiler = false
docs = false

[install]
prefix = "/usr/local"

[rust]
channel = "nightly"
codegen-units = 1
incremental = false
EOF

RUN python3 x.py install --config config.toml && \
    rm -rf /rust

FROM alexanderwagnerdev/alpine:builder AS noalbs-builder

COPY --from=rust-builder /usr/local /usr/local

RUN apk add --no-cache \
    build-base \
    musl-dev \
    git \
    pkgconfig \
    openssl-dev \
    openssl-libs-static

ENV PATH="/usr/local/bin:${PATH}"

WORKDIR /app

RUN git clone --branch v2.14.1 --depth 1 https://github.com/NOALBS/nginx-obs-automatic-low-bitrate-switching.git && \
    cd nginx-obs-automatic-low-bitrate-switching && \
    cargo build --release

FROM alexanderwagnerdev/alpine:autoupdate-stable

RUN apk update && \
    apk upgrade && \
    apk add --no-cache libgcc && \
    rm -rf /var/cache/apk/*

WORKDIR /app

COPY --from=noalbs-builder /app/nginx-obs-automatic-low-bitrate-switching/target/release/noalbs .
COPY .env .env
COPY config.json config.json

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
