#!/bin/bash --login

#SBATCH --job-name=rlee_ainik
#SBATCH --nodes=16
#SBATCH --time=24:00:00
#SBATCH --output="abinitio.log"
#SBATCH --error="abinitio.err"
#SBATCH --account=pawsey0110
#SBATCH --partition=workq
#SBATCH --export=NONE


module swap PrgEnv-cray PrgEnv-gnu
module swap gcc gcc/4.9.3
module load biopython

srun --export=all -N 16 -n 384 AbinitioRelax.mpi.linuxgccrelease @topology_broker.options



