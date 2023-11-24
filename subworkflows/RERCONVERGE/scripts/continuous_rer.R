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
# Github: https://github.com/nozerorma/caastools/nf-phylly
#
# Author:         Miguel Ramon (miguel.ramon@upf.edu)
#
# File: continuous_rer.R
#

# Set directories
## Pass as arg from nextflow config, should be $baseDir

setwd("/home/miguel/TFM/Master_projects/NEOPLASY_PRIMATES")
getwd()

workingDir <- getwd()
dataDir <- file.path(workingDir, "Data")
resultsDir <- file.path(workingDir, "Out")

# Load libraries
library(dplyr)
library(RERconverge)

# Load traitfile
neoplasiaPath <- file.path(dataDir, "Phase_I-In-silico-analysis/Neoplasia_species360/neoplasia_vector_RER.RData")
load(neoplasiaPath) # As neoplasia_vector

# Load RER matrix
treePath <- paste0(rerDir, "RERtrees/masterTree.rds")
geneTrees <- readRDS(treePath)

# Convert the trait vector to paths comparable to the paths in the RER matrix.
charpaths <- char2Paths(neoplasia_vector, geneTrees)

# Load RERs
rdsPath <- paste0(rerDir, "RERs/primRERw.rds")
primRERw <- readRDS(rdsPath)

# Perform continuous RER analysis
res=correlateWithContinuousPhenotype(primRERw, charpaths, min.sp = 10, 
    winsorizeRER = 3, winsorizetrait = 3)

## Visualize the results
head(res[order(res$p.adj),])

## Check how Pvalues are sorted
hist(res$P, breaks=100)

## Check how correlation is affected by individual clades
x=charpaths
y=primRERw['A1BG',]
pathnames=namePathsWSpecies(geneTrees$masterTree) 
names(y)=pathnames
plot(x,y, cex.axis=1, cex.lab=1, cex.main=1, xlab="Weight Change", 
    ylab="Evolutionary Rate", main="Gene ADSS Pearson Correlation",
    pch=19, cex=1, xlim=c(-2,2))
text(x,y, labels=names(y), pos=4)
abline(lm(y~x), col='red',lwd=3)
