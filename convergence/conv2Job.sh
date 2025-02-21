#!/bin/bash --login

#SBATCH --job-name=conv2
#SBATCH --nodes=1
#SBATCH --time=22:00:00
#SBATCH --output="conv2.log"
#SBATCH --error="conv2.err"
#SBATCH --account=pawsey0110
#SBATCH --partition=workq
#SBATCH --export=NONE


module swap PrgEnv-cray PrgEnv-gnu
module swap gcc gcc/4.9.3
module load biopython

srun --export=all -N 1 bash conv2v2.sh


