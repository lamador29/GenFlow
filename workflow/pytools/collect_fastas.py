import os, glob, shutil, pathlib

def find_fastas_from_defaults():
    patterns = ["data/*.fasta", "*.fasta"]
    files = []
    for pat in patterns:
        for f in glob.glob(pat):
            p = pathlib.Path(f).resolve()
            if p.exists():
                files.append(str(p))
    return sorted(set(files))

def main(fasta_csv, out_path, flag_path):
    dest = pathlib.Path("Intermediate"); dest.mkdir(exist_ok=True)
    if fasta_csv:
        files = []
        for f in fasta_csv.split(","):
            p = pathlib.Path(f.strip()).resolve()
            if p.exists():
                files.append(str(p))
    else:
        files = find_fastas_from_defaults()

    if not files:
        raise SystemExit("No FASTA files found. Provide -f or put *.fasta in ./data or cwd.")

    for f in files:
        shutil.copy2(f, dest)

    pathlib.Path(out_path).parent.mkdir(parents=True, exist_ok=True)
    open(out_path, "w").write("\n".join(files) + "\n")
    pathlib.Path(flag_path).parent.mkdir(parents=True, exist_ok=True)
    pathlib.Path(flag_path).write_text("collected\n")

if __name__ == "__main__":
    fasta_csv = snakemake.config.get("fasta")
    out_path  = snakemake.output["list"]
    flag_path = snakemake.output["flag"]
    main(fasta_csv, out_path, flag_path)
