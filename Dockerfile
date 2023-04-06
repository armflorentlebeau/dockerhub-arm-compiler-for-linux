FROM ubuntu:22.04

ARG ACFL_MAJ_VER
ARG ACFL_MIN_VER

RUN if ! [ "$(arch)" = "aarch64" ] ; then exit 1; fi

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y install vim wget sudo git make cmake tar
RUN apt-get -y install environment-modules python3 libc6-dev
RUN apt-get clean

ENV USER=ubuntu
RUN useradd --create-home -s /bin/bash -m $USER && echo "$USER:ubuntu" | chpasswd && adduser $USER sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN wget https://developer.arm.com/-/media/Files/downloads/hpc/arm-compiler-for-linux/${ACFL_MAJ_VER}-${ACFL_MIN_VER}/arm-compiler-for-linux_${ACFL_MAJ_VER}.${ACFL_MIN_VER}_Ubuntu-22.04_aarch64.tar
RUN tar xf arm-compiler-for-linux_${ACFL_MAJ_VER}.${ACFL_MIN_VER}_Ubuntu-22.04_aarch64.tar
RUN cd arm-compiler-for-linux_${ACFL_MAJ_VER}.${ACFL_MIN_VER}_Ubuntu-22.04 && ./arm-compiler-for-linux_${ACFL_MAJ_VER}.${ACFL_MIN_VER}_Ubuntu-22.04.sh -a
RUN rm -rf arm-compiler-for-linux_${ACFL_MAJ_VER}.${ACFL_MIN_VER}_Ubuntu-20.04*

RUN echo "source /usr/share/modules/init/bash" >> /home/ubuntu/.bashrc
RUN echo "module use /opt/arm/modulefiles" >> /home/ubuntu/.bashrc
RUN echo "module load binutils acfl gnu" >> /home/ubuntu/.bashrc
RUN echo "echo Arm Compiler for Linux environment loaded." >> /home/ubuntu/.bashrc

WORKDIR /home/ubuntu
USER ubuntu
