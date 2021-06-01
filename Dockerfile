FROM ubuntu:20.04

USER root
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin" apt-get install -y --no-install-recommends \
    gcc-10 g++-10 cmake make git wget dpkg-dev \
    libxerces-c-dev libexpat-dev libboost-python-dev python3.9-dev && \
    apt-get autoremove --purge && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

CMD /io/build.sh
