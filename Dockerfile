FROM golang:1.18

ARG USERNAME=go
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME


# Required for building the Oracle DB driver
ADD oci8.pc /usr/lib/pkgconfig/oci8.pc
ADD instantclient-basic-linux.x64-*.zip ./
ADD instantclient-sdk-linux.x64-*.zip ./

RUN apt-get update && apt-get install -y --no-install-recommends \
		unzip \
        libaio1 \
        && rm -rf /var/lib/apt/lists/*

# Unzip instant client.
RUN unzip instantclient-basic-linux.x64-*.zip -d / \
    && unzip instantclient-sdk-linux.x64-*.zip -d / \
    && ln -s /instantclient_11_2/libclntsh.so.11.1 /instantclient_11_2/libclntsh.so

# The package config doesn't seem to be enough, this is also required.
ENV LD_LIBRARY_PATH /instantclient_11_2

USER $USERNAME
