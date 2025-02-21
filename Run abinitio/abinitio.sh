#!/bin/bash --login

#SBATCH --job-name=abinitio
#SBATCH --nodes=8
#SBATCH --time=20:00:00
#SBATCH --output="abinitio.log"
#SBATCH --error="abinitio.err"
#SBATCH --account=pawsey0110
#SBATCH --partition=workq
#SBATCH --export=NONE


module swap PrgEnv-cray PrgEnv-gnu
module swap gcc gcc/4.9.3
module load biopython

srun --export=all -N 8 -n 192 AbinitioRelax.mpi.linuxgccrelease @topology_broker.options