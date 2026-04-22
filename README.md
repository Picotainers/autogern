# AutoGERN

Container image for [AutoGERN](https://github.com/JChander/AutoGERN), a graph neural network framework for inferring gene regulatory networks from single-cell RNA-seq data.

## Citation

If you use AutoGERN in your research, cite the original paper:

> Chander J. et al. AutoGERN: single-cell RNA-seq gene regulatory network inference via explicit link modeling and adaptive architectures. Bioinformatics (2026). https://doi.org/10.1093/bioinformatics/btag143

## Pull the image

```bash
docker pull docker.io/picotainers/autogern:latest
```

## Basic usage

Show the CLI help:

```bash
docker run --rm docker.io/picotainers/autogern:latest --help
```

Run the bundled example dataset from the upstream repository:

```bash
docker run --rm docker.io/picotainers/autogern:latest \
  --dataset /opt/autogern/data/mDC/TF+500/
```

Mount your own data directory:

```bash
docker run --rm -v "$(pwd):/data" docker.io/picotainers/autogern:latest \
  --dataset /data/TF+500/
```

## Notes

- The image uses CPU PyTorch wheels so it is runnable on standard Docker hosts.
- The upstream example data is bundled at `/opt/autogern/data`.
