FROM ubuntu:20.04
MAINTAINER mongenae@its.jnj.com

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

ENV STAR_VERSION 2.7.8a
ENV RSEM_VERSION 1.3.3

RUN apt-get update && \
    apt-get upgrade -y 

RUN apt-get install -y zlibc zlib1g zlib1g-dev make gcc g++ wget
RUN apt-get install -y r-base-core libboost-dev
RUN apt-get install -y libncurses-dev libbz2-dev liblzma-dev
RUN apt-get install -y bowtie bowtie2

WORKDIR /home

RUN wget --no-check-certificate https://github.com/alexdobin/STAR/archive/${STAR_VERSION}.tar.gz
RUN tar -xzf ${STAR_VERSION}.tar.gz
WORKDIR /home/STAR-${STAR_VERSION}/source
RUN make STAR
ENV PATH /home/STAR-${STAR_VERSION}/source:${PATH}

WORKDIR /home

RUN wget --no-check-certificate https://github.com/deweylab/RSEM/archive/refs/tags/v${RSEM_VERSION}.tar.gz
RUN tar -xzf v${RSEM_VERSION}.tar.gz
WORKDIR /home/RSEM-${RSEM_VERSION}
RUN make
RUN make ebseq
ENV PATH="/home/RSEM-${RSEM_VERSION}":$PATH

RUN echo "export PATH=$PATH" > /etc/environment
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" > /etc/environment
