FROM reg.aiontech.vn/redhat/ubi10-minimal:10.1 AS builder

# Install dependencies
RUN microdnf install -y tar gzip \
    git \
    gcc \
    gcc-c++ \
    glibc-devel \
    make \
    which \
    findutils \
    zlib-devel \
    libzstd-devel \
    cyrus-sasl-lib \
    cyrus-sasl-devel

# ========================================================= End Add Go User For Non-Root =========================================================

# ========================================================= Download Go =========================================================
# Set Go version
ENV GO_VERSION=1.26.4

# Download and install Go
RUN curl -LO https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
# ========================================================= End Download Go =========================================================

# ========================================================= Install Kafka Lib =========================================================
RUN git clone --branch v2.10.1  https://github.com/edenhill/librdkafka.git && \
    cd librdkafka && \
    ./configure --install-deps && \
    make && \
    make install && \
    cd .. && \
    rm -rf librdkafka
# ========================================================= End Install Kafka Lib =========================================================


FROM reg.aiontech.vn/redhat/ubi10-minimal:10.1

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

COPY --from=builder /usr/local/go /usr/local/go
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include/librdkafka /usr/local/include/librdkafka

# Optional: persist the LD path
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/librdkafka.conf && ldconfig

# Set Go environment variables
ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

