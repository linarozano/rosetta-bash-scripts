#!/bin/bash
#Lrlrlr 030619 checkerr.sh
#to check for errors in abinitio.err for the submitted jobs
#for abinitio runs
#run in parent directory containing 10k)cv, 1k_cv ...etc


for d in ./*_cv
do 
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		wc -l abinitio.err
		cd ..
	fi
done	
echo "Errors listed as in the sequence of these folders: 10-1-20-2.5-30-40-50-5-7.5"