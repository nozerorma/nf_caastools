#!/bin/bash
#SBATCH --job-name=nfct-discovery-4f
#SBATCH -p haswell
#SBATCH --cpus-per-task=4
#SBATCH --output=Out.txt
#SBATCH --error=Err.txt
#SBATCH --time=8:00:00

# send mail if needed
#SBATCH --mail-type=START,END,FAIL
#SBATCH --mail-user=miguel.ramon@upf.edu

#Define modules
module load Nextflow

# run caastools in nextflow
nextflow run main.nf -with-singularity -profile cluster,singularity --ct_tool discovery --traitfile config-t4.tab
