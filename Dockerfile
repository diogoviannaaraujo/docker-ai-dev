ARG CUDA_VERSION=12.6.3
ARG from=nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu22.04

FROM ${from} AS base

ARG DEBIAN_FRONTEND=noninteractive
RUN <<EOF
apt update -y && apt upgrade -y && apt install -y --no-install-recommends  \
    git \
    git-lfs \
    python3 \
    python3-pip \
    python3-dev \
    wget \
    fonts-liberation \
    run-one \
&& rm -rf /var/lib/apt/lists/*
EOF

RUN pip install jupyterlab

RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126

# Set the working directory in the container
WORKDIR /workdir

# Copy the requirements file
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

