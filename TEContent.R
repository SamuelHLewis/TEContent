#!/usr/bin/env Rscript

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("Biostrings"))
suppressPackageStartupMessages(library("ggplot2"))

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
	output=c(GenomeSize,TESize,TErel)
	return(output)
}

#########################
# user argument parsing #
#########################

# create parser object
parser <- ArgumentParser()
# parse input genome filename
parser$add_argument("-f", "--genomefiles", type="character", help="Genome fasta file")
# parse input TE filename
parser$add_argument("-t", "--tefiles", type="character", help="Transposable element fasta file")
# collect arguments
args <- parser$parse_args()
# assign arguments to variables
GenomeFiles = strsplit(args$genomefiles,",")[[1]]
TEFiles = strsplit(args$tefiles,",")[[1]]
# check that the same number of Genome files and TE files have been given
if (length(GenomeFiles)==length(TEFiles)) {
	sprintf("Each genome file has an accompanying TE file - looking good")
} else {
	stop("ERROR: there are different numbers of genome and TE files")
}

####################
# function calling #
####################

# empty vectors to hold results for each genome
Genomes=NULL
GenomeSizes=NULL
TESizes=NULL
TEProps=NULL

# TEContent called on each genome-TE file pair, and results sorted into separate vectors
for (i in 1:length(GenomeFiles)){
	cat("Calculating TE content for ",GenomeFiles[i]," & ",TEFiles[i],"\n",sep="")
	results=TEContent(GenomeFiles[i],TEFiles[i])
	Genomes = append(Genomes,GenomeFiles[i])
	GenomeSizes = append(GenomeSizes,as.integer(results[[1]]))
	TESizes = append(TESizes,as.integer(results[[2]]))
	TEProps = append(TEProps,as.double(results[[3]]))
}
# results reformatted to matrix
Output=as.data.frame(cbind(Genomes,GenomeSizes,TESizes,TEProps))
print(Output)

# plot genome size vs TE proportion
plot=ggplot(data=Output)
plot=plot+theme_bw()
plot=plot+geom_point(aes(x=GenomeSizes,y=TEProps,colour=Genomes),size=4)
pdf(file = "TEContentplot.pdf",width=10.5,height=6.75)
plot
dev.off()
