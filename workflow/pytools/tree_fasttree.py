import subprocess, pathlib
def main(in_alignment, out_tree):
    out = pathlib.Path(out_tree); out.parent.mkdir(parents=True, exist_ok=True)
    with open(out,"w") as fh:
        subprocess.check_call(["FastTree","-nt", in_alignment], stdout=fh)
if __name__ == "__main__":
    main(snakemake.input[0], snakemake.output[0])
