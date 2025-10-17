#!/usr/bin/env python3
import argparse, pathlib, yaml, subprocess, os

ROOT = pathlib.Path(__file__).resolve().parents[2]

def main():
    ap = argparse.ArgumentParser(description="GenFlow (entrada Python)")
    ap.add_argument("-f","--fasta", default=None)
    ap.add_argument("-g","--genomes", default="data/genomes.txt")
    ap.add_argument("-t","--threads", type=int, default=2)
    ap.add_argument("-G","--geom", type=float, default=0.8)
    ap.add_argument("-F","--func", type=float, default=0.8)
    ap.add_argument("-N","--dna", action="store_true")
    ap.add_argument("-I","--inflation", type=int, default=10)
    ap.add_argument("--mode", choices=["bacteria","fungi"], default="bacteria")
    ap.add_argument("--outdir", default="results")
    ap.add_argument("--env-root", default=os.path.expanduser("~/.genflow/env"))
    args = ap.parse_args()

    cfg = {
        "mode": args.mode,
        "outdir": args.outdir,
        "threads": args.threads,
        "G": args.geom,
        "F": args.func,
        "mcl_inflation": args.inflation,
        "genomes": args.genomes,
        "fasta": args.fasta,
        "DNA_mode": bool(args.dna),
        "env_root": args.env_root
    }
    (ROOT/"workflow"/"config").mkdir(parents=True, exist_ok=True)
    (ROOT/"workflow"/"config"/"config.yaml").write_text(yaml.safe_dump(cfg, sort_keys=False))

    snakefile = ROOT/"workflow"/"Snakefile"
    subprocess.check_call(["snakemake","-s",str(snakefile),
                           "--cores",str(args.threads),
                           "--printshellcmds"])

if __name__ == "__main__":
    main()
