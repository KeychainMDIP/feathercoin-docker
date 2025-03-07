FROM ubuntu:22.04
RUN \
        apt-get update && \
        apt-get install -y software-properties-common && \
        apt-get install -y apt-utils && \
        apt-get install -y git vim less python3 curl && \
        apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils

RUN git clone --depth 1 --branch v0.19.2 https://github.com/FeatherCoin/Feathercoin.git

WORKDIR /Feathercoin

COPY detect_arch_build_depends.sh /Feathercoin/detect_arch_build_depends.sh
RUN chmod +x /Feathercoin/detect_arch_build_depends.sh

RUN . ./detect_arch_build_depends.sh && \
    ./autogen.sh && \
    CONFIG_SITE="$PWD/depends/$DETECTED_HOST/share/config.site" ./configure \
        --prefix=/usr/local \
        --with-gui=no \
        --disable-tests \
        --disable-bench

RUN make -j "$(nproc)"
RUN make install
RUN strip /usr/local/bin/feathercoin*
RUN rm -rf /Feathercoin

WORKDIR /root
RUN mkdir /root/.feathercoin
CMD ["feathercoind", "-printtoconsole"]
