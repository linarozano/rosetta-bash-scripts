#!/bin/bash --login
#SBATCH --job-name=post_ab_1
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --output="post_ab1.log"
#SBATCH --error="post_ab1.err"
#SBATCH --account=pawsey0110
#SBATCH --partition=workq
#SBATCH --export=NONE


module swap PrgEnv-cray PrgEnv-gnu
module swap gcc gcc/4.9.3
module load biopython

srun --export=all -N 1 -n 24 bash post_ab1.sh
