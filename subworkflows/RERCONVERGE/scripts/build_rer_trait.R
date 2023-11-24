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
# File: build_rer_trait.R
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

# Load traitfile
## Pass as arg from nextflow config, should be
cancer_traits <- read.csv(file.path(dataDir, "Phase_I-In-silico-analysis/Neoplasia_species360/species360_primates_neoplasia_20230519.csv"))

## Remove whitespaces
cancer_traits[] <- lapply(cancer_traits, function(col) trimws(col))

## Binarize names
cancer_traits$species <- gsub(" ", "_", cancer_traits$species)

## Reorder and filter species
cancer_traits <- cancer_traits %>%
  select(species,neoplasia_prevalence) %>%
  filter(!is.na(neoplasia_prevalence))

# Select only those columns of interest and build named vector
neoplasia_vector <- setNames(as.numeric(cancer_traits$neoplasia_prevalence), cancer_traits$species)
head(neoplasia_vector)

# Write the generated vector
## Parameterize to traits_continuous
neoplasiaPath <- file.path(dataDir, "Phase_I-In-silico-analysis/Neoplasia_species360/neoplasia_vector_RER.RData")
save(neoplasia_vector, file = neoplasiaPath)

### DONE ###
