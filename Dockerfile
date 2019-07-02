FROM alpine:3.8 as builder
# install gcc , autoconf , make
RUN { \
        echo "http://mirrors.aliyun.com/alpine/v3.8/main"; \
        echo "http://mirrors.aliyun.com/alpine/v3.8/community"; \
    } > /etc/apk/repositories

RUN apk add autoconf g++ gcc make libffi-dev openssl-dev readline 
RUN mkdir /build
ADD zssh-1.5a.tgz /build
WORKDIR /build/zssh-1.5a

# build zssh from source
RUN autoheader && ./configure --disable-readline || true
RUN make

# build lrzsz from souce
WORKDIR /build/zssh-1.5a/lrzsz-0.12.20/
RUN ./configure || true
RUN make

# cp binnary from builder
FROM alpine:3.8
RUN { \
        echo "http://mirrors.aliyun.com/alpine/v3.8/main"; \
        echo "http://mirrors.aliyun.com/alpine/v3.8/community"; \
    } > /etc/apk/repositories

COPY --from=builder /build/zssh-1.5a/zssh /usr/bin/zssh
COPY --from=builder /build/zssh-1.5a/lrzsz-0.12.20/src/lrz /usr/bin/rz
COPY --from=builder /build/zssh-1.5a/lrzsz-0.12.20/src/lsz /usr/bin/sz
RUN apk add openssh