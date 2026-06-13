FROM registry.redhat.io/ubi10/ubi-minimal:10.1 AS builder

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

# ========================================================= Install Kafka Lib =========================================================
RUN git clone --branch v2.10.1  https://github.com/edenhill/librdkafka.git && \
    cd librdkafka && \
    ./configure --install-deps && \
    make && \
    make install && \
    cd .. && \
    rm -rf librdkafka
# ========================================================= End Install Kafka Lib =========================================================


FROM registry.redhat.io/ubi10/ubi-minimal:10.1

RUN microdnf install -y \
        libaio \
        glibc \
        shadow-utils \
        cyrus-sasl-lib --nodocs

RUN microdnf upgrade \
    sqlite-libs \
    libxml2 \
    && microdnf clean all \
    && rm -rf /var/cache/* /var/tmp/*

# ========================================================= Install Oracle Instant Client =========================================================
RUN curl -LO https://yum.oracle.com/repo/OracleLinux/OL8/oracle/instantclient21/x86_64/getPackage/oracle-instantclient-basic-21.13.0.0.0-1.el8.x86_64.rpm && \
    curl -LO https://yum.oracle.com/repo/OracleLinux/OL8/oracle/instantclient21/x86_64/getPackage/oracle-instantclient-devel-21.13.0.0.0-1.el8.x86_64.rpm && \
    rpm -ivh *.rpm && \
    rm -f *.rpm
# ========================================================= End Install Oracle Instant Client =========================================================


ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include/librdkafka /usr/local/include/librdkafka

# Optional: persist the LD path
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/librdkafka.conf && ldconfig