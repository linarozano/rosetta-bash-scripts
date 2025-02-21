#!/bin/bash
#Lrlrlr 130319 combineRun_calibur
#Usage: to run bash script in all sub directories and save all output in new folder Calibur_data
#Script: calibur_clust.sh
#Magnus version

mkdir Cluster_data		#Create new folder to store output calibur.out
echo ./* | xargs -n 1 cp *sh	#Copy calibur.sh and caliburJobs.sh scripts into all directories

for d in ./*; do (cd "$d" && rm silent*); done

for d in ./*; do (cd "$d" && cat *fsc | awk '{print $NF".pdb"}' | sed 1d  > 10k_calibur.txt); done 	#Generate 10k_calibur.txt for clustering from score.fsc

for d in ./*; do (cd "$d" && bash calibur_clust.sh); done	#Execute caliburJobs.sh sbatch on Magnus

# Rename output based on directory name
for d in ./*; do mv $d/calibur10k.out $d.calibur; done;		

mv *.calibur Calibur_data/	#Move all to new folder Calibur_data





