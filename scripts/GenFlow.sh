#!/bin/bash
#  GenFlow Launcher (Snakemake version)
#  Adapted by Laura Amador

cd "$(dirname "$0")/.." || exit 1
# Start time
start_time=$(date +%s)

############################################################
# Help                                                     #
############################################################
Help() {
    echo "Don't worry; sometimes we also don't know what to do."
    echo
    echo "Syntax: GenFlow [-f|-h|-g|-t|-G|-F|-N|-I]"
    echo "Options:"
    echo "-g     A txt file containing all accession numbers of reference (g)enomes (default: genomes.txt)"
    echo "-h     Print this (h)elp."
    echo "-f     Your genomes in (f)asta file format. If you have more than one, provide file names separated by commas:"
    echo "       file1.fasta,file2.fasta,etc. If you do not specify it, GenFlow will use all fasta in the folder."
    echo "-t     Number of (t)hreads, don't be too rude with your computer."
    echo "-G     (G)eometric Index value for selecting core genes (default: 0.8)."
    echo "-F     (F)unctional Index value for selecting core genes (default: 0.8)."
    echo "-N     Use this option to work with (N)ucleotide sequences instead of amino acid sequences. It requires a lot of RAM!!"
    echo "-I     Set the (I)nflation value for MCL (default: 10, recommended for highly related genomes)."
}

############################################################
# Main program                                             #
############################################################

# Set default variables
Fasta=()
threads="8"
G="0.8"
F="0.8"
genomes="genomes.txt"  # Default to genomes.txt
DNA_mode=false  # Default to not using DNA mode
mcl_inflation=2  # Default inflation value

# Process the input options
while getopts ":hf:g:t:G:F:NI:" option; do
    case $option in
        h) # Display Help
            Help
            exit;;
        f) # FASTA file(s)
            IFS=',' read -r -a Fasta <<< "$OPTARG" ;;  # Allow multiple files separated by commas
        g) # Accession numbers in txt format
            genomes="$OPTARG";;  # Set genomes file from -g argument
        t) # Number of threads
            threads="$OPTARG";;
        G) # Geometric Index
            G="$OPTARG";;		
        F) # Functional Index
            F="$OPTARG";;
        N) # Enable DNA mode
            DNA_mode=true;;
        I) # Set MCL inflation value
            mcl_inflation="$OPTARG";;  # Set inflation value from -I argument
        \?) # Invalid option
            echo "Error: Invalid option"
            Help
            exit;;
    esac
done

# If no FASTA files were specified, try to default to all .fasta files in the directory
if [[ ${#Fasta[@]} -eq 0 ]]; then
    Fasta=(*.fasta)
fi

# Debugging: Print the genomes file being checked
echo "Using genomes file: $genomes"

# Check if the genomes file exists
if [[ ! -f "$genomes" ]]; then
    echo "Error: File '$genomes' not found in the directory."
    exit 1
fi

# Print all FASTA files being used
echo "Using FASTA files: ${Fasta[@]}"

# Check if any FASTA files were found
if [[ ${#Fasta[@]} -eq 0 ]]; then
    echo "Error: No FASTA files found."
    exit 1
fi
# Debugging: Check if DNA mode is enabled
if [ "$DNA_mode" = true ]; then
    echo "Using DNA mode"
else
    echo "Using PROTEIN mode"
fi

############################################################
# Launch Snakemake                                         #
############################################################
echo "Launching GenFlow pipeline via Snakemake..."
echo

# Activate conda environment if needed
if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    echo "Conda environment detected: $CONDA_DEFAULT_ENV"
else
    echo "No active conda environment detected. Please activate GenFlow environment first:"
    echo "conda activate GenFlow"
    exit 1
fi

# Ensure directories and configuration exist
mkdir -p results Intermediate logs config

CONFIG_FILE="config/config.yaml"

# Create default config if missing
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "No config/config.yaml found — creating default one..."
    cat > "$CONFIG_FILE" <<'EOF'
outdir: "results"
threads: 4
G: 0.8
F: 0.8
mcl_inflation: 10
genomes: "Data/genomes.txt"
fasta: null
DNA_mode: false
use_ncbi_download: false
run_ani: false
use_raxml: false
mode: "bacteria"
EOF
fi

# Print key configuration info
echo "Using configuration file: $CONFIG_FILE"
grep -E "^(mode|use_raxml|threads)" "$CONFIG_FILE" || echo "(no mode/thread info found)"
echo

# Detect FASTA files automatically if not provided
if [ -z "$fasta" ]; then
    fasta=$(ls Data/*.fasta 2>/dev/null | tr '\n' ',' | sed 's/,$//')
fi
snakemake -s workflow/Snakefile \
    --cores "$threads" \
    --printshellcmds \
    --rerun-incomplete \
    --config \
        fasta="$fasta" \
        genomes="$genomes" \
        threads="$threads" \
        G="$G" \
        F="$F" \
        DNA_mode="$DNA_mode" \
        mcl_inflation="$mcl_inflation"

snakemake_exit=$?

############################################################
# Check status and show results                            #
############################################################
if [ $snakemake_exit -eq 0 ]; then
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    hours=$((duration / 3600))
    minutes=$(((duration % 3600) / 60))
    echo
    echo "GenFlow completed successfully!"
    echo "Results available in: ./results/"
    echo "Time elapsed: ${hours}h ${minutes}m"
else
    echo
    echo "Snakemake execution failed. Check logs/ and .snakemake/log/ for details."
    exit 1
fi