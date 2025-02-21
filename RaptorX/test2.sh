#!/bin/bash
#Lrlrlr 201019 raptorx.sh
#script to analyse raptorx results

#2) concatenate all results from ModelRank.rtf (could be in two domain folders)
for d in ./*.all_in_one	
do
	cd "$d" 
	for e in ./dom*
	do
		cd "$e"
		cp *.rtf $e.rtf
		mv $e.rtf ../
		cd ..
	done
	cat *.rtf > combined
	rm *.rtf
	mv combined $d.combined 
	mv *combined ../
	cd ..
done

cat *combined > results.txt
rm *combined

