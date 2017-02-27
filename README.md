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
