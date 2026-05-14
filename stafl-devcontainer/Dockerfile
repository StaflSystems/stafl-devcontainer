# See here for image contents: https://github.com/docker-library/buildpack-deps/blob/master/ubuntu/resolute/curl/Dockerfile

ARG VARIANT="resolute"

FROM buildpack-deps:${VARIANT}-curl
ARG VARIANT
ARG TARGETPLATFORM

# Remove 'ubuntu' user
RUN if [ "$VARIANT" = "noble" ] || [ "$VARIANT" = "resolute" ]; then \
    if id "ubuntu" &>/dev/null; then \
        echo "Deleting user 'ubuntu'  for $VARIANT" && userdel -f -r ubuntu || echo "Failed to delete ubuntu user for $VARIANT"; \
    else \
         echo "User 'ubuntu' does not exist for $VARIANT"; \
    fi; \
    fi

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y reinstall --no-install-recommends tzdata unzip \
    && echo "Etc/UTC" > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

RUN curl -s -o features.zip https://codeload.github.com/devcontainers/features/zip/refs/heads/main \
  && unzip features.zip \
  && USERNAME=vscode USER_UID=1000 USER_GID=1000 bash features-main/src/common-utils/install.sh \
  && rm -rf features-main features.zip


RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get --no-install-recommends -y full-upgrade \
  && apt-get -y install --no-install-recommends bash-completion bzip2 ca-certificates clang clang-format curl \ 
     dos2unix doxygen g++ g++-s390x-linux-gnu gcc-s390x-linux-gnu gdb gdb-multiarch git git-lfs \
     gnupg graphviz inetutils-ping ksh lcov llvm lldb libclang-rt-dev make ninja-build openjdk-25-jdk plantuml python3 python3-dev \
     python3-pip python3-venv qemu-user ripgrep software-properties-common udev wget xz-utils \
  && add-apt-repository -y -n ppa:xtradeb/apps \
  && add-apt-repository -y -n ppa:deadsnakes/ppa \
  && curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
  && apt-get update \
  && apt-get -y install --no-install-recommends nodejs chromium libpython3.8 \
  && npm install -g https://github.com/maphstr/mdpdf.git \
  && npm install -g @withgraphite/graphite-cli@stable \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Install GCC ARM 13.3 Rel 1
RUN case ${TARGETPLATFORM} in \
  "linux/amd64") GCC_ARM_ARCH=x86_64  ;; \
  "linux/arm64") GCC_ARM_ARCH=aarch64 ;; \
  esac \
  && wget -q https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-$GCC_ARM_ARCH-arm-none-eabi.tar.xz \
   -O gcc-arm-none-eabi.tar.xz \
  && tar -xf gcc-arm-none-eabi.tar.xz \
  && rm gcc-arm-none-eabi.tar.xz \
  && mv arm-gnu-toolchain-13.3.rel1-${GCC_ARM_ARCH}-arm-none-eabi gcc-arm-none-eabi-13.3.rel1 \
  && mv gcc-arm-none-eabi-13.3.rel1/bin/arm-none-eabi-gdb gcc-arm-none-eabi-13.3.rel1/bin/arm-none-eabi-gdb-non-py \
  && ln -s /opt/gcc-arm-none-eabi-13.3.rel1/bin/arm-none-eabi-gdb-py /opt/gcc-arm-none-eabi-13.3.rel1/bin/arm-none-eabi-gdb

# Install GCC ARM 15.2 Rel 1
RUN case ${TARGETPLATFORM} in \
  "linux/amd64") GCC_ARM_ARCH=x86_64  ;; \
  "linux/arm64") GCC_ARM_ARCH=aarch64 ;; \
  esac \
  && wget -q https://developer.arm.com/-/media/Files/downloads/gnu/15.2.rel1/binrel/arm-gnu-toolchain-15.2.rel1-$GCC_ARM_ARCH-arm-none-eabi.tar.xz \
   -O gcc-arm-none-eabi.tar.xz \
  && tar -xf gcc-arm-none-eabi.tar.xz \
  && rm gcc-arm-none-eabi.tar.xz \
  && mv arm-gnu-toolchain-15.2.rel1-${GCC_ARM_ARCH}-arm-none-eabi gcc-arm-none-eabi-15.2.rel1 \
  && mv gcc-arm-none-eabi-15.2.rel1/bin/arm-none-eabi-gdb gcc-arm-none-eabi-15.2.rel1/bin/arm-none-eabi-gdb-non-py \
  && ln -s /opt/gcc-arm-none-eabi-15.2.rel1/bin/arm-none-eabi-gdb-py /opt/gcc-arm-none-eabi-15.2.rel1/bin/arm-none-eabi-gdb

WORKDIR /

#### Install jlink ####
# URLs copied from https://www.segger.com/downloads/jlink/
ARG JLINK_URL_x86_64="https://www.segger.com/downloads/jlink/JLink_Linux_V938_x86_64.deb"
ARG JLINK_URL_ARM="https://www.segger.com/downloads/jlink/JLink_Linux_V938_arm64.deb"

RUN case ${TARGETPLATFORM} in \
  "linux/amd64") JLINK_URL=$JLINK_URL_x86_64 ;; \
  "linux/arm64") JLINK_URL=$JLINK_URL_ARM ;; \
  esac \
  && wget -q "$JLINK_URL" --post-data="accept_license_agreement=accepted" -O ./jlink_install.deb \
  && /lib/systemd/systemd-udevd --daemon \
  && apt update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ./jlink_install.deb \
  && rm ./jlink_install.deb \
  && rm -rf /var/lib/apt/lists/*

# Install SafeRTOS JLink plug-in
ADD utilities/RTOSPlugin_SafeRTOS_ubuntu-latest.so /opt/stafl-systems/RTOSPlugin_SafeRTOS_ubuntu-latest.so
RUN chmod +x /opt/stafl-systems/RTOSPlugin_SafeRTOS_ubuntu-latest.so

#### Install CMake ####
ARG CMAKE_VERSION="4.3.2"
RUN case ${TARGETPLATFORM} in \
  "linux/amd64") CMAKE_ARCH=x86_64  ;; \
  "linux/arm64") CMAKE_ARCH=aarch64 ;; \
  esac \
  && wget -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-${CMAKE_ARCH}.sh -O cmake.sh \
  && chmod +x cmake.sh \
  && bash cmake.sh --skip-license --prefix=/usr/local \
  && rm cmake.sh

#### Install CCache ####
RUN case ${TARGETPLATFORM} in \
  "linux/amd64") CCACHE_ARCH=x86_64  ;; \
  "linux/arm64") CCACHE_ARCH=aarch64 ;; \
  esac \
  && wget -q https://github.com/StaflSystems/ccache/releases/download/v4.12.2/ccache-iarsupport.26383df4-linux-${CCACHE_ARCH}.tar.xz -O ccache.tar.xz \
  && tar -xf ccache.tar.xz \
  && mv ccache-iarsupport.26383df4-linux-${CCACHE_ARCH}/ccache /usr/local/bin/ccache \
  && rm ccache.tar.xz \
  && rm -rf ccache-iarsupport.26383df4-linux-${CCACHE_ARCH}

  # Add user setup scripts
ADD user-setup-scripts /user-setup-scripts

#### Install UV ####
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/bin/
