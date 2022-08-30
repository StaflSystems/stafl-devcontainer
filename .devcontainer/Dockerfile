# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.205.1/containers/ubuntu/.devcontainer/base.Dockerfile

ARG VARIANT="jammy"

FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}
ARG VARIANT
ARG TARGETPLATFORM

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends clang llvm-14 clang-format-14 g++ lcov gdb ninja-build wget bzip2 python2.7-dev python3 python3-pip gcc-multilib-mips-linux-gnu gcc-mips-linux-gnu g++-mips-linux-gnu qemu-user libncurses5 graphviz plantuml make \
    && pip install cmake \
    && ln -s /usr/bin/llvm-cov-14 /usr/bin/llvm-cov

WORKDIR /opt

# Install GCC ARM
RUN case ${TARGETPLATFORM} in \
    "linux/amd64") GCC_ARM_ARCH=x86_64  ;; \
    "linux/arm64") GCC_ARM_ARCH=aarch64 ;; \
    esac \
    && wget -q https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-$GCC_ARM_ARCH-linux.tar.bz2 -O gcc-arm-none-eabi.tar.bz2 \
    && tar -xjf gcc-arm-none-eabi.tar.bz2 \
    && rm gcc-arm-none-eabi.tar.bz2 \
    && mv gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-gdb gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-gdb-non-py \
    && ln -s /opt/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-gdb-py /opt/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-gdb

# # Install TI CGT ARM
RUN if [ "$TARGETPLATFORM" != "linux/arm64" ]; then \
      echo "Installing TI CGT TMS470" \
      && wget -q https://software-dl.ti.com/codegen/esd/cgt_public_sw/TMS470/20.2.5.LTS/ti_cgt_tms470_20.2.5.LTS_linux-x64_installer.bin -O ti-cgt-installer.bin \
      && chmod +x ti-cgt-installer.bin \
      && ./ti-cgt-installer.bin --mode=unattended --prefix /opt/ti-cgt-arm \
      && rm ti-cgt-installer.bin \
      && PATH=/opt/ti-cgt-arm/ti-cgt-arm_20.2.5.LTS/bin:$PATH /opt/ti-cgt-arm/ti-cgt-arm_20.2.5.LTS/lib/mklib --pattern=rtsv7M4_T_le_v4SPD16_eabi_eh.lib \
      && chmod -R 777 /opt/ti-cgt-arm; \
    else \
      echo "skipping TI CGT TMS470. Not supported on arm64"; \
    fi
# Install Tivaware
ADD build/TivaWare_C_Series-2.2.0.295 /opt/TivaWare_C_Series-2.2.0.295

# Allow opt dir to be written
RUN chmod -R -v 777 /opt
