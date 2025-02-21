#!/bin/bash
#Lrlrlr 120319 runJobs_abintio.sh
#Usage: script to copy default files for abinitio modelling; 
#1)native.pdb 2)native_core.txt 3)topology_broker.options 4)topology_broker.tpb and 5)abinitio.sh 
#into each subdirectories containing t000_.fasta and 3&9 fragment files
#and run abinitio.sh in sbatch submitting jobs to magnus
#Run script in parent directory containing the subdirectories
#Command: bash runJobs_abinitio.sh


#Copy contents in subdirectory example into each subdirectories
echo *_m | xargs -n 1 cp example/*	#Copy contents in directory example into all directories

#Evoke sbatch of abinitio.sh
for d in ./*; do (cd "$d" && sbatch abinitio.sh); done	#Execute abinitio.sh in all subdirectories as job submission