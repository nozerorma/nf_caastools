#!/bin/bash
#SBATCH --job-name=nfct-discovery
#SBATCH -p haswell
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH -e slurm-%j.err
#SBATCH -o slurm-%j.out
#SBATCH --time=8:00:00

# send mail if needed
#SBATCH --mail-type=START,END,FAIL
#SBATCH --mail-user=miguel.ramon@upf.edu

#Define modules
module load Nextflow

# Define the directory where trait files are located
TRAIT_DIR="/gpfs42/robbyfs/scratch/lab_anavarro/mramon/nf_caastools/Out/4.CAAS_analysis/Traitfiles/"

# Loop through trait files in the directory with a .tab file extension
for TRAIT_FILE in "$TRAIT_DIR"*.tab
do
        # Run caastools in Nextflow using the current trait file
        srun -n1 --exclusive nextflow run main.nf -with-singularity -with-tower -profile singularity --ct_tool discovery --traitfile "$TRAIT_FILE" &
done

wait
