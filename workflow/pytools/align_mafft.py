import pathlib, subprocess
def main(in_fasta, out_aln, threads=2):
    out = pathlib.Path(out_aln); out.parent.mkdir(parents=True, exist_ok=True)
    cmd = ["mafft","--retree","1","--thread",str(threads),"--maxiterate","0",in_fasta]
    with open(out,"w") as out_fh:
        subprocess.check_call(cmd, stdout=out_fh)
if __name__ == "__main__":
    thr = int(snakemake.config.get("threads",2))
    main(snakemake.input[0], snakemake.output[0], thr)
