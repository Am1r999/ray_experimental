FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    unzip \
    psmisc \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    git \
    clang-12 \
    pkg-config \
    && apt-get clean

RUN python3 --version
COPY . /ray
WORKDIR /ray
RUN ci/env/install-bazel.sh

# Let's Build the dashboard
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.40.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh
RUN nvm install 14 \
    && nvm use 14
WORKDIR /ray/python/ray/dashboard/client
RUN npm ci
RUN npm run build

WORKDIR /ray/python
RUN export RAY_BACKEND_LOG_LEVEL=debug
RUN ln -s /usr/bin/python3 /usr/bin/python 
RUN python3.10 -m pip install --upgrade pip
RUN python3.10 -m pip install setuptools
RUN python3.10 -m pip install python-dev-tools
RUN python3.10 -m pip install -r requirements.txt
RUN python3.10 -m pip install -e . --verbose
RUN python -m pip install torch
CMD ["/bin/bash"]
