#!/bin/bash
#Lrlrlr 160719 compressClust.sh
#only compress clusters pdb in MasterPDB folder for each Clusters folders.

for d in ./*_cv
do
	cd "$d"
	for x in ./Cluster*
	do
		cd "$x"
		cd MasterPDB
		tar -cjf masterpdb.tar.bz2 cluster*.pdb
		rm cluster*.pdb
		cd ../../
	done
	cd ..
done
