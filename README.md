# GenFlow legacy workflow

This branch, `snakemake-fungi`, preserves the older GenFlow workflow with Docker/Singularity support and FastTree. The IQ-TREE migration belongs to `snakemake-fungi-version-2`.

## Run with Conda

Create or activate the environments described in `envs/`. The legacy workflow expects separate environments for Prokka, Roary, UFCG, RAxML, and ANI tools.

For the bacterial accession test set in `Data/short.txt`:

```bash
conda activate genflow
python3 scripts/genflow.py -m bacteria -t 4 -d --genomes Data/short.txt
```

The accession file must contain one `GCF_` or `GCA_` accession per line. The command downloads the genomes, annotates them, runs the pangenome workflow, aligns the core genes, and writes the tree to:

```text
results/phylogenomic-tree.txt
```

For local FASTA files instead of NCBI accessions:

```bash
conda activate genflow
python3 scripts/genflow.py -m bacteria -t 4 \
  --fasta "Data/INISA09F.fasta,Data/INISA10F.fasta,Data/INISA16F.fasta"
```

## Docker

The legacy container files are under `container/`. To use the container workflow:

```bash
cd container
docker compose up --build
```

See `container/README.md` for the container-specific details.

## Verify a run

After the workflow finishes, check the tree and logs:

```bash
test -s results/phylogenomic-tree.txt
head -c 200 results/phylogenomic-tree.txt
ls -lh results/phylogenomic-tree.txt results/aligned.named.fasta
ls -lh logs/
```

Generated directories such as `results/`, `Intermediate/`, `logs/`, and `.snakemake/` should not be committed.
