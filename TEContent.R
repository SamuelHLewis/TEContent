#!/usr/bin/env Rscript

suppressPackageStartupMessages(library("argparse"))

#########################
# user argument parsing #
#########################

# create parser object
parser <- ArgumentParser()
# parse input genome filename
parser$add_argument("-f", "--genomefile", type="character", help="Genome fasta file")
# parse input TE filename
parser$add_argument("-t", "--tefile", type="character", help="Transposable element fasta file")
# collect arguments
args <- parser$parse_args()
# assign arguments to variables
Genome = args$genomefile
TE = args$tefile

sprintf("Input genome file = %s", Genome)
sprintf("Input TE file = %s", TE)
