# DOCKER QUICK COMMANDS

# Build image (from container/ directory)
docker-compose build

# Build without cache
docker-compose build --no-cache

# Run workflow
docker-compose run --rm genflow -c \
  "snakemake --cores 8 --use-conda --config fasta='Data/*.fasta'"

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
