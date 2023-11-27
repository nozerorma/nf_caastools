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
# File: rer_objects.R
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

setwd(dir(args[1]))
getwd()

workingDir <- getwd()
dataDir <- file.path(workingDir, "Data")
createDir(dataDir)
resultsDir <- file.path(workingDir, "Out")
createDir(resultsDir)

# Load libraries
library(dplyr)
library(RERconverge)

# Generating RER directory if not exists
rerDir <- file.path(resultsDir, "RERConverge/")
createDir(rerDir)

# Reading in gene trees with `readTrees`
geneTreesPath <- file.path(dataDir, args[1])

## Generating masterTree
geneTrees <- readTrees(geneTreesPath) # Set max.read = 100 to toy-up

## Write our masterTree to path
treePath <- paste0(rerDir, "RERtrees/")
createDir(treePath)
saveRDS(geneTrees, paste0(treePath, "rerMatrix.rds"))


# Load our traits
neoplasiaPath <- file.path(dataDir, args[2])
load(neoplasiaPath) # As neoplasia_vector

# Get residuals from our traitfile
primRERw <- getAllResiduals(geneTrees,useSpecies=names(neoplasia_vector), 
    transform = "sqrt", weighted = T, scale = T)

# Now we save our RERs

## Save to path
rdsPath <- paste0(rerDir, "RERs/")
createDir(rdsPath)
saveRDS(primRERw, paste0(rdsPath, "primRERw.rds")) 

# Pickup all trees
multirers <- returnRersAsTreesAll(geneTrees,primRERw)

## Write our multiRERs
write.tree(multirers, paste0(rdsPath, "multiRERw.rds"), tree.names=TRUE)

### DONE ###
