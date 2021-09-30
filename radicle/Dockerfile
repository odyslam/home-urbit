# FROM balenalib/raspberrypi4-64-debian-node
FROM  node:latest
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        git \
        ; \
    apt-get autoremove; \
    rm -rf /var/lib/apt/lists/*
# RUN npm install -g yarn
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN mkdir /radicle-seed
WORKDIR /radicle-seed
COPY start-radicle-seed.sh /usr/sbin/start-radicle-seed.sh
RUN chmod +x /usr/sbin/start-radicle-seed.sh
RUN git clone https://github.com/radicle-dev/radicle-bins.git
WORKDIR /radicle-seed/radicle-bins
RUN (ls && cd ./seed/ui && yarn && yarn build)
RUN ls && cargo run -p radicle-keyutil -- --filename /radicle-seed/secret.key
ENTRYPOINT ["/usr/sbin/start-radicle-seed.sh"]
