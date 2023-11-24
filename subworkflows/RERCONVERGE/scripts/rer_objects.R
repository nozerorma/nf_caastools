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
# File: rer_objects.R
#

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Unlock the secrets of evolutionary relationships with Phylophere! 🌳🔍 This Nextflow pipeline
# packs a powerful punch, offering a comprehensive suite of phylogenetic comparative tools
# and analyses. Dive into the world of evolutionary biology like never before and elevate
# your research to new heights! 🚀🧬 #Phylophere #EvolutionaryInsights #NextflowPipeline
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

# Common functions

createDir <- function(directory) {
  if (!file.exists(directory)) {
    dir.create(directory, recursive = TRUE)
  }
}

# Reading in gene trees with `readTrees`
### Parameterize

geneTreesPath <- file.path(dataDir, "Phase_I-In-silico-analysis/Gene_trees/ALL_FEB23_geneTrees.txt")
geneTrees <- readTrees(geneTreesPath) # Set max.read = 100 to toy-up

# Load our traits
neoplasiaPath <- file.path(dataDir, "Phase_I-In-silico-analysis/Neoplasia_species360/neoplasia_vector_RER.RData")
load(neoplasiaPath) # As neoplasia_vector

# Get residuals from our traitfile
primRERw <- getAllResiduals(geneTrees,useSpecies=names(neoplasia_vector), 
    transform = "sqrt", weighted = T, scale = T)

## Now we save our RERs

### Create rerDir if not exist
rerDir <- file.path(resultsDir, "7.RERConverge/RERs/")
createDir(rerDir)

### Save to path
rdsPath <- paste0(rerDir, "primRERw.rds")
saveRDS(primRERw, rdsPath) 

# Pickup all trees
multirers <- returnRersAsTreesAll(geneTrees,primRERw)

## Save to path
multiRERPath <- paste0(rerDir, "multiRERw.rds")

## Write our multiRERs
write.tree(multirers, multiRERPath, tree.names=TRUE)
