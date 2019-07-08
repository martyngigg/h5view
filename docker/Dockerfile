FROM ubuntu:bionic

# install dependencies
RUN apt-get update && \
    # Install prerequisite tools
    apt-get install -y \
      apt-transport-https \
      build-essential \
      cmake \
      libhdf5-dev \
      ninja-build \
      cppcheck && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# create source and build
RUN mkdir -p /h5view_src && \
    mkdir -p /h5view_build

# allow mounting source and build
VOLUME ["h5view_src", "h5view_build"]

# drop straight into build
WORKDIR /h5view_build
