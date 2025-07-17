FROM oraclelinux:8-slim as builder

# Install dependencies
RUN microdnf install -y curl tar gzip \
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


FROM oraclelinux:8-slim

# ========================================================= Add Go User For Non-Root =========================================================
ARG USERNAME=go
ARG USER_UID=1000
ARG USER_GID=1000

# Create group and user
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} --create-home --shell /bin/bash ${USERNAME}
# ========================================================= End Add Go User For Non-Root =========================================================

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include/librdkafka /usr/local/include/librdkafka

# Optional: persist the LD path
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/librdkafka.conf && ldconfig
