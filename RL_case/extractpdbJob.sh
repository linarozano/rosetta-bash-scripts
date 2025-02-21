#!/bin/bash --login

#SBATCH --job-name=ext_com
#SBATCH --nodes=1
#SBATCH --time=08:00:00
#SBATCH --output="ext_com.log"
#SBATCH --error="ext_com.err"
#SBATCH --account=pawsey0110
#SBATCH --partition=workq
#SBATCH --export=NONE


module swap PrgEnv-cray PrgEnv-gnu
module swap gcc gcc/4.9.3
module load biopython

srun --export=all -N 1 bash extractpdb_andcompress.sh



