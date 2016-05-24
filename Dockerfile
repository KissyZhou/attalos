FROM l41-keras-base

# Install git, bc and dependencies
RUN apt-get update && apt-get install -y \
  git \
  bc \
  cmake \
  libatlas-base-dev \
  libatlas-dev \
  libboost-all-dev \
  libopencv-dev \
  libprotobuf-dev \
  libgoogle-glog-dev \
  libgflags-dev \
  protobuf-compiler \
  libhdf5-dev \
  libleveldb-dev \
  liblmdb-dev \
  libsnappy-dev \
  python-dev \
  python-pip \
  python-numpy \
  gfortran > /dev/null

# Clone Caffe repo and move into it
RUN cd /root && git clone https://github.com/BVLC/caffe.git && cd caffe && \
# Install python dependencies
    cat python/requirements.txt | xargs -n1 pip install

RUN cd /root/caffe && \
# Make and move into build directory
  mkdir build && cd build && \
# CMake
  cmake .. && \
# Make
  make -j"$(nproc)" all && \
  make install

# Add to Python path
ENV PYTHONPATH=/root/caffe/python:$PYTHONPATH

# Set ~/caffe as working directory
WORKDIR /root/caffe

RUN pip install --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.8.0-cp27-none-linux_x86_64.whl

