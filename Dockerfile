FROM alpine:3.8 as builder
# install gcc , autoconf , make
RUN { \
        echo "http://mirrors.aliyun.com/alpine/v3.8/main"; \
        echo "http://mirrors.aliyun.com/alpine/v3.8/community"; \
    } > /etc/apk/repositories

RUN apk add autoconf gcc make libffi-dev openssl-dev readline 
RUN apk add g++
RUN mkdir /build
ADD zssh-1.5a.tgz /build
WORKDIR /build/zssh-1.5a
RUN ls & autoheader && ./configure --disable-readline || true
RUN make
# build from source

# cp from builder
FROM alpine:3.8
COPY --from=builder /build/zssh-1.5a/zssh /usr/bin/zssh