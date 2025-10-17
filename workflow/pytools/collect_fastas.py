import os, glob, shutil, pathlib
def main(fasta_csv, out_path, flag_path):
    dest = pathlib.Path("Intermediate"); dest.mkdir(exist_ok=True)
    files = []
    if fasta_csv:
        for f in fasta_csv.split(","):
            p = pathlib.Path(f.strip())
            if p.exists(): files.append(str(p.resolve()))
    else:
        files = [str(pathlib.Path(p).resolve()) for p in glob.glob("*.fasta")]
    if not files:
        raise SystemExit("No FASTA files found. Provide -f or put *.fasta in cwd.")
    for f in files: shutil.copy2(f, dest)
    pathlib.Path(out_path).parent.mkdir(parents=True, exist_ok=True)
    open(out_path,"w").write("\n".join(files)+"\n")
    pathlib.Path(flag_path).parent.mkdir(parents=True, exist_ok=True)
    pathlib.Path(flag_path).write_text("collected\n")
if __name__ == "__main__":
    fasta_csv = snakemake.config.get("fasta")
    out_path  = snakemake.output["list"]
    flag_path = snakemake.output["flag"]
    main(fasta_csv, out_path, flag_path)
