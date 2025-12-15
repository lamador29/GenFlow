# GenFlow Docker Image
# Multi-stage build for optimized final image

FROM continuumio/miniconda3:latest AS builder

LABEL maintainer="GenFlow Team"
LABEL description="GenFlow - Bacterial and Fungal Genomic Workflow"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    CONDA_AUTO_UPDATE_CONDA=false \
    PATH=/opt/conda/bin:$PATH

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    curl \
    git \
    nano \
    less \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create application directory
WORKDIR /workspace/GenFlow

# Copy conda environment files
COPY envs/ /tmp/envs/

# Create conda environments
RUN conda config --system --prepend channels conda-forge \
    && conda config --system --set auto_update_conda false

# Install each environment from yml files
RUN for env_file in /tmp/envs/*.yml; do \
    echo "Installing environment from $env_file" && \
    conda env create -f "$env_file" || true; \
    done

# Create base genflow environment for general tools
RUN conda create -y -n genflow-base \
    -c bioconda -c conda-forge \
    snakemake \
    python=3.10 \
    && conda clean -afy

# Final stage
FROM continuumio/miniconda3:latest

ENV DEBIAN_FRONTEND=noninteractive \
    CONDA_AUTO_UPDATE_CONDA=false \
    PATH=/opt/conda/bin:$PATH

# Install minimal runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    git \
    nano \
    less \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy conda environments from builder
COPY --from=builder /opt/conda /opt/conda

# Set working directory
WORKDIR /workspace/GenFlow

# Copy project files (context is root, so no ../ needed)
COPY scripts/ ./scripts/
COPY Data/ ./Data/
COPY .gitignore ./

# Create necessary directories
RUN mkdir -p Intermediate results logs \
    && chmod -R 755 /workspace/GenFlow

# Initialize conda for shell interaction
RUN conda init bash

# Set entrypoint to bash with conda activated
SHELL ["/bin/bash", "--login", "-c"]

ENTRYPOINT ["/bin/bash"]
CMD ["-i"]
