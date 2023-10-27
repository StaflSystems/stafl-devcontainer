# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.205.1/containers/ubuntu/.devcontainer/base.Dockerfile

ARG VARIANT="jammy"

FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}
ARG VARIANT
ARG TARGETPLATFORM

# Add user setup scripts
ADD user-setup-scripts /user-setup-scripts

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get -y install --no-install-recommends curl clang llvm-14 clang-format-14 doxygen g++ lcov gdb ninja-build wget bzip2 python2.7-dev python3 python3-pip python3-dev gcc-multilib-mips-linux-gnu gcc-mips-linux-gnu g++-mips-linux-gnu qemu-user libncurses5 graphviz plantuml make software-properties-common udev \
  && pip install cmake breathe sphinx sphinx_rtd_theme sphinxcontrib-plantuml sphinxcontrib-kroki \
  && ln -s /usr/bin/llvm-cov-14 /usr/bin/llvm-cov \
  && ln -s /usr/bin/llvm-profdata-14 /usr/bin/llvm-profdata \
  && add-apt-repository -y -n ppa:mozillateam/ppa \
  && add-apt-repository -y -n ppa:saiarcot895/chromium-beta \
  && cat /user-setup-scripts/firefox/firefox-pin.txt > /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${VARIANT}";' > /etc/apt/apt.conf.d/51unattended-upgrades-firefox \
  && curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - \
  && apt-get update \
  && apt-get -y install --no-install-recommends nodejs firefox chromium-browser \
  && npm -g install https://github.com/maphstr/mdpdf.git \
  && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash \
  && sudo apt-get install git-lfs

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

# Allow opt dir to be written
RUN chmod -R -v 777 /opt

WORKDIR /

#### Install jlink ####
# URLs copied from https://www.segger.com/downloads/jlink/
ARG JLINK_URL_x86_64="https://www.segger.com/downloads/jlink/JLink_Linux_V792_x86_64.deb"
ARG JLINK_URL_ARM="https://www.segger.com/downloads/jlink/JLink_Linux_V792_arm64.deb"

RUN case ${TARGETPLATFORM} in \
  "linux/amd64") JLINK_URL=$JLINK_URL_x86_64 ;; \
  "linux/arm64") JLINK_URL=$JLINK_URL_ARM ;; \
  esac \
  && sudo wget -q "$JLINK_URL" --post-data="accept_license_agreement=accepted" -O ./jlink_install.deb \
  && sudo /lib/systemd/systemd-udevd --daemon \
  && sudo apt install -y ./jlink_install.deb \
  && rm ./jlink_install.deb

ARG STRUCTURIZR_CLI_URL="https://github.com/structurizr/cli/releases/download/v1.33.1/structurizr-cli-1.33.1.zip"
RUN sudo wget -q "${STRUCTURIZR_CLI_URL}" -O ./structurizr.zip \
    && sudo unzip structurizr.zip -d /usr/bin/structurizr  \
    && sudo ln -s /usr/bin/structurizr/structurizr.sh /usr/bin/structurizr/structurizr \
    && PATH=/usr/bin/structurizr:$PATH \ 
    && sudo rm structurizr.zip