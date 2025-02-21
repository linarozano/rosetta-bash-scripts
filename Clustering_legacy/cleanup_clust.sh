#!/bin/bash
#Lrlrlr 250619 cleanup_clust.sh
#to cleanup folders Cluster2-6, Master PDB, by creating tar.bz2 and delete single pdbs

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
