FROM alpine:3.18 as builder
# install gcc , autoconf , make
RUN apk add autoconf g++ gcc make libffi-dev openssl-dev readline 
RUN mkdir /build
ADD zssh-1.5c.tgz /build
WORKDIR /build/zssh-1.5c

# build zssh from source
RUN autoheader && ./configure --disable-readline || true
RUN make

# build lrzsz from souce
WORKDIR /build/zssh-1.5c/lrzsz-0.12.20/
RUN ./configure || true
RUN make

# cp binnary from builder
FROM alpine:3.18

COPY --from=builder /build/zssh-1.5c/zssh /usr/bin/zssh
COPY --from=builder /build/zssh-1.5c/lrzsz-0.12.20/src/lrz /usr/bin/rz
COPY --from=builder /build/zssh-1.5c/lrzsz-0.12.20/src/lsz /usr/bin/sz
RUN apk add --no-cache \
    openssh-client
