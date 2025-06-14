# docker build -t ap2 .
#
# docker run --privileged -h ap2 --rm -it -v ${PWD}:/host --user $(id -u) -w /home/dev ap2 bash

FROM python:3.9.21-bookworm
MAINTAINER Davide Viti <zinosat@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get update -yq && DEBIAN_FRONTEND=noninteractive apt-get install wget gpg lsb-release -yq

RUN DEBIAN_FRONTEND=noninteractive apt-get update -yq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  build-essential ca-certificates less git sudo \
  pkg-config libusb-1.0-0-dev cargo gcc-arm-none-eabi libstdc++-arm-none-eabi-newlib python3 wget python3-pip gcc unzip wget zip gcc-avr binutils-avr avr-libc dfu-programmer dfu-util gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi apt-utils build-essential

RUN python3 -m pip install qmk
RUN qmk setup -y

RUN adduser --disabled-password --gecos '' dev && \
    adduser dev sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN cd /home/dev; sudo -H -u dev git clone https://github.com/OpenAnnePro/AnnePro2-Tools.git && \
    cd AnnePro2-Tools && cargo build --release
    
RUN cd /home/dev; sudo -H -u dev git clone https://github.com/tgdnt/qmk_firmware.git annepro-qmk --recursive --depth 1 && \
    cd annepro-qmk && ./util/qmk_install.sh && make annepro2/c18

RUN cd /home/dev; sudo -H -u dev git clone https://github.com/tgdnt/AnnePro2-Shine.git --recursive --depth 1 && \
    cd AnnePro2-Shine && make C18

RUN cp /home/dev/AnnePro2-Tools/target/release/annepro2_tools /home/dev/
RUN cp /home/dev/annepro-qmk/.build/annepro2_c18_default.bin /home/dev/
RUN cp /home/dev/AnnePro2-Shine/build/C18/annepro2-shine-C18.bin /home/dev/

ENV TZ /usr/share/zoneinfo/America/Chicago
