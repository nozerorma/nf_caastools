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
# File: build_rer_trait.R
#

# Set up variable to control command line arguments
args <- commandArgs(TRUE)

# Load libraries
library(dplyr)
library(RERconverge)

# Load traitfile
## File must have a multi-column structure with at least a "species" and "trait" column
ori_traits <- read.csv(args[1])

## Remove whitespaces
ori_traits[] <- lapply(ori_traits, function(col) trimws(col))

## Binarize names if not performed already
ori_traits$species <- gsub(" ", "_", ori_traits$species)

# IN HERE I HAVE TO STREAMLINE CODE SO ANY TRAIT CAN BE INSERTED
## Reorder and filter species
ori_traits <- ori_traits %>%
  select(species,args[2]) %>%
  filter(!is.na(args[2]))

# Select only those columns of interest and build named vector
trait_vector <- setNames(as.numeric(ori_traits$args[2]), ori_traits$species)
head(trait_vector)

# Write the generated vector
## Parameterize to traits_continuous
traitPath <- args[3]
print(traitPath)
save(trait_vector, file = traitPath)

### DONE ###
