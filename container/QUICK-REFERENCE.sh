#!/bin/bash
# Quick Reference for GenFlow Container Commands
# Note: Run docker-compose and singularity commands from container/ directory

# DOCKER QUICK COMMANDS

# Build image (from container/ directory)
docker-compose build

# Build without cache
docker-compose build --no-cache

# Run workflow
docker-compose run --rm genflow -c \
  "snakemake --cores 8 --use-conda --config fasta='Data/*.fasta'"

# Interactive shell
docker-compose run --rm genflow -i

# View conda environments
docker-compose run --rm genflow -c "conda env list"

# Check tools
docker-compose run --rm genflow -c "which prokka snakemake"

# View logs
tail -f ../logs/prokka.log
tail -f ../logs/roary.log

# SINGULARITY QUICK COMMANDS

# Build from Docker image (from container/ directory)
./docker-to-singularity.sh convert genflow:latest genflow.sif

# Build from definition file
./docker-to-singularity.sh build-def genflow.sif

# Test image
./docker-to-singularity.sh test genflow.sif

# Run workflow (from container/ directory)
singularity run genflow.sif snakemake --cores 8 --use-conda \
  --config fasta='../Data/*.fasta'

# Interactive shell
singularity shell genflow.sif

# COMMON WORKFLOWS

# Bacteria with local FASTA
docker-compose run --rm genflow -c \
  "snakemake --cores 8 --use-conda --config fasta='Data/genome1.fasta,Data/genome2.fasta'"

# Bacteria with NCBI download
docker-compose run --rm genflow -c \
  "snakemake --cores 8 --use-conda --config use_ncbi_download=true genomes='Data/genomes.txt'"

# Bacteria with RAxML
docker-compose run --rm genflow -c \
  "snakemake --cores 8 --use-conda --config fasta='Data/*.fasta' use_raxml=true"

# Bacteria with ANI
docker-compose run --rm genflow -c \
  "snakemake --cores 8 --use-conda --config fasta='Data/*.fasta' run_ani=true"

# Fungi (requires 4+ genomes)
docker-compose run --rm genflow -c \
  "snakemake --cores 8 --use-conda --config mode=fungi genomes='Data/genomes.txt'"

# HPC SLURM SUBMISSION

# Save this as genflow_job.sh
#!/bin/bash
#SBATCH --job-name=genflow
#SBATCH --time=24:00:00
#SBATCH --output=genflow.log

cd /path/to/GenFlow
singularity run genflow.sif snakemake --use-conda --config fasta='Data/*.fasta'

# Submit: sbatch genflow_job.sh

# TROUBLESHOOTING

# Docker daemon not running
sudo systemctl start docker

# Permission denied (Docker)
sudo usermod -aG docker $USER
# Log out and back in

# Rebuild container (clear cache)
docker-compose build --no-cache

# View Docker image size
docker images genflow

# Clean up Docker
docker system prune -a

# Clean up Singularity
rm -f *.sif

# DOCUMENTATION

# See README.md for complete guide
