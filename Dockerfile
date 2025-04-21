ARG CUDA_VERSION=12.4.1
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
    gh \
&& rm -rf /var/lib/apt/lists/*
EOF

RUN pip install jupyterlab

RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

RUN pip install --no-cache-dir \
    ultralytics \
    insightface \
    onnx \
    onnxruntime-gpu \
    "huggingface_hub[cli]" \
    accelerate \
    transformers \
    "qwen-vl-utils[decord]" \
    autoawq \
    tensorrt

# Copy startup script and make it executable
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

WORKDIR /workdir

# Use startup script as entrypoint
CMD ["/startup.sh"]
