#!/bin/bash
#SBATCH --job-name=rm-work-debris
#SBATCH -p haswell 
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4G
#SBATCH -e slurm-%j.err
#SBATCH -o slurm-%j.out
#SBATCH --time=8:00:00

# send mail if needed
#SBATCH --mail-type=START,END,FAIL
#SBATCH --mail-user=miguel.ramon@upf.edu

# Remove nextflow work debris
rm -rf /gpfs42/robbyfs/scratch/lab_anavarro/mramon/nf_caastools/work
