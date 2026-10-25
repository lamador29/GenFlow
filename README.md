# GenFlow

GenFlow analiza genomas y construye un arbol filogenomico.

## Antes de empezar

Se necesita:

- Windows con WSL, Linux o macOS.
- Conda o Miniforge instalado.
- Conexion a internet si se descargan genomas desde NCBI.
- Al menos 8 GB de espacio libre.

En Windows, la ejecucion debe realizarse desde una terminal de Ubuntu/WSL.

## Paso 1: descargar el proyecto

Descargar el proyecto con:

```bash
git clone URL_DEL_REPOSITORIO
cd GenFlow
```

Si la carpeta ya existe, solo es necesario entrar en ella:

```bash
cd GenFlow
```

## Paso 2: preparar Conda

El siguiente comando crea el entorno principal con las herramientas necesarias para el ejemplo bacteriano:

```bash
conda create -n genflow -c conda-forge -c bioconda \
  python=3.11 snakemake prokka mafft ncbi-datasets-cli
```

El entorno se activa con:

```bash
conda activate genflow
```

Roary y FastTree necesitan un entorno adicional. El entorno se crea con:

```bash
conda env create -f envs/roary-env.yml
```

Estos pasos se realizan una sola vez. En las siguientes sesiones, solo es necesario ejecutar `conda activate genflow`.

## Paso 3: ejecutar el ejemplo

El archivo `Data/short.txt` contiene accesiones de NCBI listas para probar el programa. El análisis se inicia con:

```bash
python3 scripts/genflow.py -m bacteria -t 4 -d --genomes Data/short.txt
```

El comando utiliza las siguientes opciones:

- `-m bacteria`: analiza genomas bacterianos.
- `-t 4`: usa cuatro hilos del procesador.
- `-d`: descarga los genomas desde NCBI.
- `--genomes Data/short.txt`: indica dónde está la lista de accesiones.

El programa descarga los genomas, los anota, busca genes compartidos, alinea esos genes y construye el arbol.

## Usar archivos FASTA propios

Cuando ya se cuenta con archivos FASTA, no es necesario utilizar `-d`. Los archivos se indican separados por comas:

```bash
python3 scripts/genflow.py -m bacteria -t 4 \
  --fasta "Data/INISA09F.fasta,Data/INISA10F.fasta,Data/INISA16F.fasta"
```

Los archivos deben existir y no estar vacios.

## Paso 4: revisar los resultados

Al terminar, el arbol debe encontrarse en:

```text
results/phylogenomic-tree.txt
```

El resultado se comprueba con:

```bash
test -s results/phylogenomic-tree.txt && echo "Arbol creado correctamente"
```

El programa tambien genera el siguiente alineamiento:

```text
results/aligned.named.fasta
```

Los mensajes de cada etapa se guardan en la carpeta `logs/`.

## Si aparece un error

Primero deben revisarse estos archivos:

```bash
cat logs/download.log
cat logs/prokka.log
cat logs/roary.log
```

Para comenzar de nuevo, solo deben eliminarse los resultados generados:

```bash
rm -rf .snakemake results logs Intermediate
mkdir -p results logs Intermediate
```

La carpeta `Data/` no debe eliminarse porque contiene los archivos de entrada.
