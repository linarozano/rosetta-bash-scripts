#!/bin/bash
#Lrlrlr 280719 checkbelow0.sh (adapted from checkerr.sh)
#Script to check the number of models that will be used in clusering from below0.scoretmalign file

#Directory /Clustering/6fubb

for d in ./*_cv
do 
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		wc -l below0.scoretmalign
		cd ..
	fi
done	
echo "Number of models being proceeded for clustering based on nstruct sequence of: 10-1-20-2.5-30-40-50-5-7.5"