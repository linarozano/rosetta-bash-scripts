#!/bin/bash --login

#SBATCH --job-name=calibur
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --output="calibur.log"
#SBATCH --error="calibur.err"
#SBATCH --account=pawsey0110
#SBATCH --partition=workq
#SBATCH --export=NONE


module swap PrgEnv-cray PrgEnv-gnu
module swap gcc gcc/4.9.3
module load biopython

srun --export=all -N 1 bash combineRun_calibur.sh
