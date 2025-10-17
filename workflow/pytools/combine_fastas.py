import pathlib, glob
def main(out_fa):
    out = pathlib.Path(out_fa); out.parent.mkdir(parents=True, exist_ok=True)
    files = sorted(glob.glob("Intermediate/*.fasta"))
    if not files: raise SystemExit("No FASTA in Intermediate/. Did collect_fastas run?")
    with open(out,"w") as OUT:
        for f in files:
            with open(f) as IN:
                txt = IN.read().rstrip()
                if not txt.endswith("\n"): txt += "\n"
                OUT.write(txt)
if __name__ == "__main__":
    main(snakemake.output[0])
