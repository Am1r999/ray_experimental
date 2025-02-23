FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    unzip \
    psmisc \
    python3 \
    python3-pip \
    python3-venv \
    git \
    clang-12 \
    pkg-config \
    && apt-get clean

RUN python3 --version
COPY . /ray
WORKDIR /ray
RUN ci/env/install-bazel.sh
# Let's not Build the dashboard
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# RUN bash -c "source ~/.bashrc"
# RUN nvm install 14
# RUN nvm use 14
# WORKDIR /ray/python/ray/dashboard/client
# RUN npm ci
# RUN npm run build
#
WORKDIR /ray/python
RUN ls 
RUN python3.12 -m pip install -r requirements.txt
RUN python3.12 -m pip install -e . --verbose

CMD ["/bin/bash"]
# # Copy the GPG file into the container
# COPY bazel-release.pub.gpg /tmp/bazel-release.pub.gpg
# # Add the GPG key
# RUN gpg --dearmor < /tmp/bazel-release.pub.gpg > /usr/share/keyrings/bazel-archive-keyring.gpg
#
# # Add the Bazel repository
# RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
#
# # Install Bazel
# RUN apt update && apt install bazel-6.5.0 -y
# RUN apt update && apt full-upgrade -y
# RUN find / -iname "bazel-6.5.0" 2>/dev/null #&& which bazel-6.5.0
# RUN ln -s /usr/bin/bazel-6.5.0 /usr/bin/bazel #&& which bazel
# RUN pip cache purge && python3 -m pip install --no-cache-dir --upgrade pip
# RUN pip install psutil setproctitle==1.2.2 colorama
# COPY . ./ray 
# WORKDIR /ray
# RUN bash ./build.sh
