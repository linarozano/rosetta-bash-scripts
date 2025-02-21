#!/bin/bash
#Lrlrlr 280719 pymol_pdb2pngSingle.sh
#Extract centroids pdbs and convert them to png in bulk, for easy viewing.
#Run in /ClusteringRESULTS/*k_cv.CLUST_DATA/
#made for unfinished runs from running pymol_pdb2png.sh

#Extract cluster centroids.pdbs from MasterPDB folder

for d in ./Cluster*
do
	cd "$d"
	cd MasterPDB 
	tar xjf masterpdb.tar.bz2
	for x in ./*.pdb
	do
		echo "load $x;" > $x.pml	#creating pymol script
		echo "set ray_opaque_background, on;" >> $x.pml
		echo "show cartoon;" >> $x.pml
		echo "color purple, ss h;" >> $x.pml
		echo "color yellow, ss s;" >> $x.pml
		echo "ray 380,380;" >> $x.pml
		echo "png $x.png;" >> $x.pml
		echo "quit;" >> $x.pml
		pymol -qxci $x.pml
		rm -rf $x.pml $x.pdb
	done
	rm *pdb #cleanup
	tar -cjf $d.PNG.tar.bz2 *.png
	rm *.png
	mv *PNG.tar.bz2 ../../
	cd ../../
done

