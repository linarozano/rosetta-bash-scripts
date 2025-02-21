#!/bin/bash --login

#SBATCH --job-name=plot
#SBATCH --nodes=1
#SBATCH --time=14:00:00
#SBATCH --output="plot.log"
#SBATCH --error="plot.err"
#SBATCH --account=pawsey0110
#SBATCH --partition=workq
#SBATCH --export=NONE


module swap PrgEnv-cray PrgEnv-gnu
module swap gcc gcc/4.9.3
module load biopython

srun --export=all -N 1 bash combineRun_magnus.sh


