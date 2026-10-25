# GenFlow

GenFlow analiza genomas y construye un arbol filogenomico. Estas instrucciones son para la version antigua del proyecto, en la rama `snakemake-fungi`. Esta version usa FastTree y conserva la opcion de Docker.

La version nueva, basada en IQ-TREE, se encuentra en `snakemake-fungi-version-2`.

## Antes de empezar

Necesitas:

- Windows con WSL, Linux o macOS.
- Conda o Miniforge instalado.
- Conexion a internet si vas a descargar genomas desde NCBI.
- Al menos 8 GB de espacio libre.

Si usas Windows, abre una terminal de Ubuntu/WSL. No uses PowerShell para ejecutar estos comandos.

## Paso 1: descargar el proyecto

En la terminal, ejecuta:

```bash
git clone URL_DEL_REPOSITORIO
cd GenFlow
```

Si ya tienes la carpeta, solo entra en ella:

```bash
cd GenFlow
```

## Paso 2: preparar Conda

Este comando crea el entorno principal con las herramientas necesarias para el ejemplo bacteriano:

```bash
conda create -n genflow -c conda-forge -c bioconda \
  python=3.11 snakemake prokka mafft ncbi-datasets-cli
```

Activa el entorno:

```bash
conda activate genflow
```

Roary y FastTree necesitan un entorno adicional:

```bash
conda env create -f envs/roary-env.yml
```

Estos pasos se hacen una sola vez. En las siguientes sesiones solo necesitas ejecutar `conda activate genflow`.

## Paso 3: ejecutar el ejemplo

El archivo `Data/short.txt` contiene accesiones de NCBI listas para probar el programa. Ejecuta:

```bash
python3 scripts/genflow.py -m bacteria -t 4 -d --genomes Data/short.txt
```

Qué significa el comando:

- `-m bacteria`: analiza genomas bacterianos.
- `-t 4`: usa cuatro hilos del procesador.
- `-d`: descarga los genomas desde NCBI.
- `--genomes Data/short.txt`: indica dónde está la lista de accesiones.

El programa descargará los genomas, los anotará, buscará genes compartidos, alineará esos genes y construirá el árbol.

## Usar archivos FASTA propios

Si ya tienes archivos FASTA, no necesitas usar `-d`. Escríbelos separados por comas:

```bash
python3 scripts/genflow.py -m bacteria -t 4 \
  --fasta "Data/INISA09F.fasta,Data/INISA10F.fasta,Data/INISA16F.fasta"
```

Los archivos deben existir y no estar vacíos.

## Paso 4: revisar los resultados

Al terminar, el árbol debe estar en:

```text
results/phylogenomic-tree.txt
```

Puedes comprobarlo con:

```bash
test -s results/phylogenomic-tree.txt && echo "Arbol creado correctamente"
```

También se genera el alineamiento:

```text
results/aligned.named.fasta
```

Los mensajes de cada etapa se guardan en la carpeta `logs/`.

## Si aparece un error

Primero revisa estos archivos:

```bash
cat logs/download.log
cat logs/prokka.log
cat logs/roary.log
```

Si quieres empezar de nuevo, elimina solo los resultados generados:

```bash
rm -rf .snakemake results logs Intermediate
mkdir -p results logs Intermediate
```

No elimines la carpeta `Data/`, porque contiene los archivos de entrada.

## Usar Docker

Docker es una alternativa para esta version antigua. Requiere Docker Desktop con integracion WSL activada.

Desde la raiz del proyecto:

```bash
cd container
docker compose up --build
```

Para instrucciones de Singularity, revisa `container/README.md`.
