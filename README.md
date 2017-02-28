# TEContent
## Purpose
Calculates the absolute and relative TE content of a genome.
## Requirements
Written in R.

Requires the following R packages:

[argparse](https://cran.r-project.org/web/packages/argparse/index.html)

[Biostrings](https://bioconductor.org/packages/release/bioc/html/Biostrings.html)

# Usage
Basic usage is:
```bash
TEContent.R --species=species1,species2,species3 --genomefile=genome1.fas,genome2.fas,genome3.fas --tefile=TE1.fas,TE2.fas,TE3.fas --phenotype="Present","Present","Absent"
```
TEContent takes four mandatory arguments:

	--species (comma-separated list of species names)

	--genomefile (comma-separated list of genome fasta files)

	--tefile (comma-separated list of TE fasta files)

	--phenotype (comma-separated list of phenotypes corresponding to each species)

TEContent also accepts two optional flags:

	--logx (use log10 scale for x axis)

	--logy (use log10 scale for y axis)
