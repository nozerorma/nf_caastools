#
#
#  ██████╗ ██╗  ██╗██╗   ██╗██╗      ██████╗ ██████╗ ██╗  ██╗███████╗██████╗ ███████╗
#  ██╔══██╗██║  ██║╚██╗ ██╔╝██║     ██╔═══██╗██╔══██╗██║  ██║██╔════╝██╔══██╗██╔════╝
#  ██████╔╝███████║ ╚████╔╝ ██║     ██║   ██║██████╔╝███████║█████╗  ██████╔╝█████╗  
#  ██╔═══╝ ██╔══██║  ╚██╔╝  ██║     ██║   ██║██╔═══╝ ██╔══██║██╔══╝  ██╔══██╗██╔══╝  
#  ██║     ██║  ██║   ██║   ███████╗╚██████╔╝██║     ██║  ██║███████╗██║  ██║███████╗
#  ╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝
#                                                                                    
#                                      
# PHYLOPHERE: A Nextflow pipeline including a complete set
# of phylogenetic comparative tools and analyses for Phenome-Genome studies
#
# Github: https://github.com/nozerorma/caastools/nf-phylophere
#
# Author:         Miguel Ramon (miguel.ramon@upf.edu)
#
# File: continuous_rer.R
#

# Set up variable to control command line arguments
args <- commandArgs(TRUE)

# Common functions
createDir <- function(directory) {
    if (!file.exists(directory)) {
        dir.create(directory, recursive = TRUE)
    }
}

# Set directories
## Pass as arg from nextflow config, should be $baseDir

workingDir <- getwd()
dataDir <- file.path(workingDir, "Data")
createDir(dataDir)
resultsDir <- file.path(workingDir, "Out")
createDir(resultsDir)

# Generating RER directory if not exists
rerDir <- file.path(resultsDir, "RERConverge/")
createDir(rerDir)

# Load libraries
library(dplyr)
library(RERconverge)

# Load traitfile
neoplasiaPath <- file.path(dataDir, args[1])
load(neoplasiaPath) # As neoplasia_vector

# Load RER matrix
treePath <- paste0(rerDir, args[2])
geneTrees <- readRDS(treePath)

# Convert the trait vector to paths comparable to the paths in the RER matrix.
charpaths <- char2Paths(neoplasia_vector, geneTrees)

# Load RERs
rdsPath <- paste0(rerDir, args[4])
primRERw <- readRDS(rdsPath)

# Perform continuous RER analysis
res=correlateWithContinuousPhenotype(primRERw, charpaths, min.sp = 10, 
    winsorizeRER = 3, winsorizetrait = 3)

## Visualize the results
head(res[order(res$p.adj),])

## Check how P-values are sorted
pdf("pvalue_sortage_rer.pdf")
p1 <- hist(res$P, breaks=100, main = "P-value distribution in RERs")
dev.off()

## Check how correlation is affected by individual clades
### Probably this should be performed in a streamlined way in a different script
x <- charpaths
y <- primRERw['A1BG',] # example
pathNames <- namePathsWSpecies(geneTrees$masterTree) 

pdf("Pearson_correlation_example.pdf")
names(y) <- pathNames
plot(x,y, cex.axis=1, cex.lab=1, cex.main=1, xlab="Weight Change", 
    ylab="Evolutionary Rate", main="Gene A1BG Pearson Correlation (Example)",
    pch=19, cex=1, xlim=c(-2,2))

text(x, y, labels = names(y), pos=4)
abline(lm(y~x), col='red',lwd=3)
dev.off()
