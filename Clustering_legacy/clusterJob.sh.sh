#!/bin/bash
#Lrlrlr 120319 submitJob.sh updated 020619
#Usage: script to run any magnus jobscript in sbatch submitting jobs to magnus
#Run script in parent directory containing the subdirectories
#Command: bash runJobs_only.sh

#Evoke sbatch of whatever.sh in each folders under parent directory
for d in ./*_cv
do 
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		sbatch clusteropJob.sh
		cd ..
	fi
done	