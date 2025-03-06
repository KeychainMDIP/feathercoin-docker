FROM ubuntu:22.04
RUN \
        apt-get update && \
        apt-get install -y software-properties-common && \
        apt-get install -y apt-utils && \
        apt-get install -y git vim less python3 && \
        apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils && \
	apt-get install -y libboost-dev libboost-system-dev libboost-filesystem-dev libboost-test-dev libboost-thread-dev && \
	apt-get install -y libssl-dev libevent-dev libsqlite3-dev libminiupnpc-dev libzmq3-dev && \
        apt-get install -y libdb-dev libdb++-dev

RUN git clone --depth 1 --branch v0.19.1 https://github.com/FeatherCoin/Feathercoin.git
WORKDIR /Feathercoin
RUN ./autogen.sh
RUN ./configure --enable-wallet --disable-tests --disable-bench --with-incompatible-bdb 
RUN make
RUN make install
RUN strip /usr/local/bin/feathercoin*
RUN rm -rf /Feathercoin
WORKDIR /root
RUN mkdir /root/.feathercoin
CMD ["feathercoind", "-printtoconsole"]
