#!/bin/bash
#Lrlrlr 120319 submitJob.sh updated 071119
#Usage: script to run any magnus jobscript in sbatch submitting jobs to magnus
#Run script in parent directory containing the subdirectories
#Command: bash runJobs_only.sh


#copy scripts into each *_cv folders
for d in ./*_cv
do 
	if [ -d ${d} ]	#only run if it is a directory
	then
		cp cluster_optimize.sh "$d"
		cp clusteropJob.sh "$d"
	fi
done	

#run sbatch for all
for d in ./*_cv
do 
	cd "$d" 
	sbatch clusteropJob.sh
	cd ..
done

