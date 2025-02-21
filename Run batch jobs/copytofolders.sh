#!/bin/bash
#Lrlrlr 020619 copytofolders.sh
#to copy required files; fragment files aat000*, fasta files t000*, psipred file,  to all folders under parent directory
#for abinitio runs
#run in parent directory containing 10k)cv, 1k_cv ...etc


for d in ./*_cv
do 
	if [ -d ${d} ]	#only run if it is a directory
	then
		cp aat000_* t000_* "$d"
		ls "$d"
	fi
done	
echo "copy done!"