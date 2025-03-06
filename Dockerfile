FROM ubuntu:22.04
RUN \
        apt-get update && \
        apt-get install -y software-properties-common && \
        apt-get install -y apt-utils && \
        apt-get install -y git vim less python3 curl && \
        apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils

RUN git clone --depth 1 --branch v0.19.2 https://github.com/FeatherCoin/Feathercoin.git

WORKDIR /Feathercoin
RUN make -C depends

RUN for d in \
        i686-pc-linux-gnu \
        x86_64-pc-linux-gnu \
        x86_64-w64-mingw32 \
        x86_64-apple-darwin14 \
        arm-linux-gnueabihf \
        aarch64-linux-gnu \
        riscv32-linux-gnu \
        riscv64-linux-gnu \
    ; do \
      if [ -d "depends/$d" ]; then \
        echo "Detected host triplet: $d"; \
        export DETECTED_HOST="$d"; \
        break; \
      fi; \
    done && \
    ./autogen.sh && \
    CONFIG_SITE="$PWD/depends/$DETECTED_HOST/share/config.site" ./configure \
        --prefix=/usr/local \
        --with-gui=no \
        --disable-tests \
        --disable-bench

RUN make
RUN make install
RUN strip /usr/local/bin/feathercoin*
RUN rm -rf /Feathercoin

WORKDIR /root
RUN mkdir /root/.feathercoin
CMD ["feathercoind", "-printtoconsole"]
