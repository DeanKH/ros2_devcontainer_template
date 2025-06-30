# ROS2 + CUDA Development Container Template
# Based on dklib and dk_perception devcontainer configurations
FROM nvcr.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

# Setup locale
RUN \
  --mount=type=cache,target=/var/cache/apt \
  --mount=type=cache,target=/var/lib/apt \
  apt-get update && \
  apt-get install -y --no-install-recommends locales && \
  locale-gen ja_JP.UTF-8 && \
  update-locale LANG=ja_JP.UTF-8

# Install OpenGL and X11 libraries for GUI applications
RUN \
  --mount=type=cache,target=/var/cache/apt \
  --mount=type=cache,target=/var/lib/apt \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  libgl1-mesa-dev \
  libglu1-mesa-dev \
  x11-apps \
  mesa-utils \
  libglvnd0 \
  libgl1 \
  libglx0 \
  libegl1

# Install basic development tools
RUN \
  --mount=type=cache,target=/var/cache/apt \
  --mount=type=cache,target=/var/lib/apt \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  curl \
  gnupg2 \
  lsb-release \
  ca-certificates \
  build-essential \
  python3-pip \
  python3-dev \
  python3-venv \
  cmake \
  ninja-build \
  clangd \
  clang-format \
  cmake-format \
  libopencv-dev \
  vim \
  wget \
  git \
  gdb \
  sudo

# Install ROS2 Humble
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN \
  --mount=type=cache,target=/var/cache/apt \
  --mount=type=cache,target=/var/lib/apt \
  apt update && \
  apt install -y --no-install-recommends \
  ros-humble-desktop \
  ros-humble-rmw-cyclonedds-cpp \
  ros-dev-tools \
  python3-colcon-common-extensions \
  python3-colcon-mixin \
  python3-rosdep \
  python3-vcstool

# Install Python packages commonly used in ROS2 development
RUN pip3 install --no-cache-dir \
  numpy \
  opencv-python \
  matplotlib \
  scipy \
  scikit-learn \
  pandas \
  seaborn \
  jupyter \
  pytest \
  black \
  isort \
  pylint \
  flake8

# Create user with same UID/GID as host (configurable via build args)
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN \
  mkdir -p /etc/sudoers.d \
  && groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && echo "$USERNAME:$USERNAME" | chpasswd \
  && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME

# Setup workspace directory
USER $USERNAME
RUN mkdir -p /home/$USERNAME/workspace/src
WORKDIR /home/$USERNAME/workspace

# Setup ROS2 environment
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN \
  bash -c "source /opt/ros/humble/setup.bash && \
  colcon mixin add default https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
  colcon mixin update default"

# Optional: Add ONNXRuntime installation placeholder
# Uncomment and modify if you need ONNXRuntime for inference
# COPY assets/onnxruntime-linux-x64-gpu-*.tgz /tmp/onnxruntime.tgz
# RUN tar -xzvf /tmp/onnxruntime.tgz -C /tmp && \
#     find /tmp/onnxruntime-*/lib/cmake -type f -exec grep -l "lib64" {} \; | xargs sed -i 's/lib64/lib/g' && \
#     cp -r /tmp/onnxruntime-*/include /usr/local/include/onnxruntime && \
#     cp -r /tmp/onnxruntime-*/lib /usr/local && \
#     rm -rf /tmp/onnxruntime-* && \
#     echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib" >> ~/.bashrc

CMD ["/bin/bash"]
