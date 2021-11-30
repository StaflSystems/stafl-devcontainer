# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.205.1/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use hirsuite or bionic on local arm64/Apple Silicon): hirsute, focal, bionic
ARG VARIANT="hirsute"
ARG TARGETPLATFORM="linux/amd64" # Run with BuildKit backend to populate automatically

FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}
ARG VARIANT
ARG TARGETPLATFORM

VOLUME /home/vscode

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends clang g++ lcov gdb ninja-build wget bzip2 python3 python3-pip gcc-multilib-mips-linux-gnu gcc-mips-linux-gnu g++-mips-linux-gnu qemu-user libncurses5 graphviz plantuml \
    && pip install cmake

WORKDIR /opt

# Install GCC ARM
RUN case ${TARGETPLATFORM} in \
    "linux/amd64") GCC_ARM_ARCH=x86_64  ;; \
    "linux/arm64") GCC_ARM_ARCH=aarch64 ;; \
    esac \
    && wget -q https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-$GCC_ARM_ARCH-linux.tar.bz2 -O gcc-arm-none-eabi.tar.bz2 \
    && tar -xjf gcc-arm-none-eabi.tar.bz2 \
    && rm gcc-arm-none-eabi.tar.bz2

# Install TI CGT ARM
RUN wget -q https://software-dl.ti.com/codegen/esd/cgt_public_sw/TMS470/20.2.5.LTS/ti_cgt_tms470_20.2.5.LTS_linux-x64_installer.bin -O ti-cgt-installer.bin \
    && chmod +x ti-cgt-installer.bin \
    && ./ti-cgt-installer.bin --mode=unattended --prefix /opt/ti-cgt-arm \
    && rm ti-cgt-installer.bin

# Install Tivaware
ADD build/TivaWare_C_Series-2.2.0.295 /opt/TivaWare_C_Series-2.2.0.295

# Allow opt dir to be written
RUN chmod -R 777 /opt
