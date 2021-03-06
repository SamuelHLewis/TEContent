#!/usr/bin/env Rscript

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("Biostrings"))
suppressPackageStartupMessages(library("ggplot2"))

TEContent <- function(GenomeFile,TEFile) {
	# read in genome file and calculate total size
	Genome = readDNAStringSet(GenomeFile)
	GenomeSize = sum(as.numeric(width(Genome)))
	# read in TE file and calculate total size
	TE = readDNAStringSet(TEFile)
	TESize = sum(width(TE))
	TErel = (TESize/GenomeSize)*100
 	# format output
	output=c(GenomeSize,TESize,TErel)
	return(output)
}

#########################
# user argument parsing #
#########################

# create parser object
parser <- ArgumentParser()
# parse species name
parser$add_argument("-s", "--species", type="character", help="Genome fasta file")
# parse input genome filename
parser$add_argument("-f", "--genomefiles", type="character", help="Genome fasta file")
# parse input TE filename
parser$add_argument("-t", "--tefiles", type="character", help="Transposable element fasta file")
# parse phenotype status
parser$add_argument("-p", "--phenotype", type="character", help="Phenotype observed in each genome/species")
# optional flag for log10 scale on x axis
parser$add_argument("-x", "--logx", action="store_true", default=FALSE, help="Optional flag to plot x axis using log10 scale")
# optional flag for log10 scale on y axis
parser$add_argument("-y", "--logy", action="store_true", default=FALSE, help="Optional flag to plot y axis using log10 scale")
# optional flag for boxplot output
parser$add_argument("-b", "--boxplot", action="store_true", default=FALSE, help="Optional flag to output boxplot as well as scatterplot")
# collect arguments
args <- parser$parse_args()
# assign arguments to variables
SpeciesNames = strsplit(args$species,",")[[1]]
GenomeFiles = strsplit(args$genomefiles,",")[[1]]
TEFiles = strsplit(args$tefiles,",")[[1]]
Phenotype = strsplit(args$phenotype,",")[[1]]
# check that the same number of species names, genome files and TE files have been given
if (length(SpeciesNames)==length(GenomeFiles) && length(SpeciesNames)==length(TEFiles) && length(GenomeFiles)==length(TEFiles)) {
	sprintf("Each species has an accompanying genome file & TE file - looking good")
} else {
	stop("ERROR: there are different numbers of species, genome files and TE files")
}

####################
# function calling #
####################

# empty vectors to hold results for each genome
Species=character()
Genomes=character()
GenomeSizes=numeric()
TESizes=numeric()
TEProps=numeric()

# TEContent called on each genome-TE file pair, and results sorted into separate vectors
for (i in 1:length(GenomeFiles)){
	cat("Calculating TE content for ",GenomeFiles[i]," & ",TEFiles[i],"\n",sep="")
	results=TEContent(GenomeFiles[i],TEFiles[i])
	Species = append(Species,SpeciesNames[i])
	Genomes = append(Genomes,GenomeFiles[i])
	GenomeSizes = append(GenomeSizes,as.numeric(results[[1]]/1000000))
	TESizes = append(TESizes,as.numeric(results[[2]]/1000000))
	TEProps = append(TEProps,as.double(results[[3]]))
}

# results reformatted to matrix (for screen output only)
Output=as.data.frame(cbind(Species,Genomes,GenomeSizes,TESizes,TEProps),stringsAsFactors=FALSE)
print(Output)

# plot genome size vs TE proportion
plot=ggplot()
plot=plot+theme_bw()
plot=plot+geom_point(aes(x=GenomeSizes,y=TEProps,colour=Phenotype),size=4)
plot=plot+geom_text(aes(x=GenomeSizes,y=TEProps,colour=Phenotype,label=Species),hjust=-0.2)
if ( args$logx ){
	plot=plot+scale_x_log10()
}
if ( args$logy ){
	plot=plot+scale_y_log10()
}
pdf(file = "TEContentplot.pdf",width=10.5,height=6.75)
plot=plot+xlab("Genome size (Mb)")+ylab("TE content (%)")
plot
dev.off()

# output boxplot if specified
if ( args$boxplot ){
boxplot=ggplot()
boxplot=boxplot+theme_bw()
boxplot=boxplot+geom_boxplot(aes(x=Phenotype,y=TEProps,fill=Phenotype))
boxplot=boxplot+theme(legend.position="none")
boxplot=boxplot+xlab("Phenotype")+ylab("TE content (%)")
pdf(file = "TEContentboxplot.pdf",width=7,height=7)
print(boxplot)
dev.off()
sprintf("Boxplot written")
}

