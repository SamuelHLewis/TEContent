#!/usr/bin/env Rscript

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("Biostrings"))

TEContent <- function(GenomeFile,TEFile) {
	sprintf("Input genome file = %s", GenomeFile)
	sprintf("Input TE file = %s", TEFile)
	# read in genome file and calculate total size
	Genome = readDNAStringSet(GenomeFile)
	GenomeSize = sum(width(Genome))
	sprintf("Genome size (bp) = %i",GenomeSize)
	# read in TE file and calculate total size
	TE = readDNAStringSet(TEFile)
	TESize = sum(width(TE))
	sprintf("TE content (bp) = %i",TESize)
	TErel = (TESize/GenomeSize)*100
	sprintf("TE content (%%) = %f",TErel)
 	# format output
	titles=c("Genome size (bp)","TE content (bp)","TE content (%)")
	stats=c(GenomeSize,TESize,TErel)
	output=rbind(titles,stats)
	return(output)
}

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
GenomeFile = args$genomefile
TEFile = args$tefile

####################
# function calling #
####################

TEContent(GenomeFile,TEFile)

