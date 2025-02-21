#!/bin/bash
#Lrlrlr compileClust.sh edited on 051119 for combined_postclusterv2.sh
#Combined script 1
#to compile clustering results so its easy to backup Clustering results on Rdrive
#to be quick run on zeus, submit as job

mkdir ClusteringRESULTS
for d in ./*_cv
do
	cd "$d"
	mkdir CLUST_DATA
	mv Cluster* Plots_clustering below0* *below0 clusopt* CLUST_DATA
	mv CLUST_DATA $d.CLUST_DATA
	mv *CLUST_DATA ../ClusteringRESULTS
	cd ..
done

#Combined script 2
#Lrlrlr 240719 post_cluster.sh
#To analyse clustering results of nstruct 1k-50k (independently)
#and select for the best rmsd/radius to use

#The directory to analyse. Example: 5zlvd/ClusteringRESULTS/
#Create new table rank based on biggest cluster and list of centroid and total number of members. (As in excel file prev.

cd ClusteringRESULTS
for x in ./*CLUST_DATA
do
	cd "$x"
	mkdir Centroids
	for d in ./Cluster*
	do
		cd "$d"
		awk '{A[$6]++}END{for(i in A)print i,A[i]}' *.cluster_table > temp_uniq #calculate unique number in column 6
		cat *.cluster_table | awk '$7<1' | sort -nk 6 > temp_sort #capture only centroid in each cluster. member equals to 0
		paste temp_uniq temp_sort | column -s $'\t' -t > $d.centroids #append temp into final table
		rm temp* #cleanup
		cp *centroids ../Centroids
		cd ..
	done
	cd ..
done

#save column 3 as pdb list to extract from original or masterPDB (labelled)

#In ./*CLUST_DATA/Centroids --in arrangement 2,3,4,5,6
#get just the biggest cluster in one summary table

for x in ./*CLUST_DATA
do
	cd "$x"
	cd Centroids
	for d in ./*.centroids
	do
		cat $d | sort -nk 2 | tail -1 > $d.temp
	done
	cat *temp > $x.summary
	cp *summary ../../
	cd ../../
done

mkdir CentroidSUM
mv *.summary CentroidSUM
cd CentroidSUM
#concatenate file with header seperator
tail -n +1  1k*summary 2p*summary 5k*summary 7p*summary 10k*summary 20*summary 30*summary 40*summary 50*summary > ClusterSummary
mv ClusterSummary ../

#Combined script 3
#Lrlrlr 250719 pymol_pdbpng.sh
#Extract centroids pdbs and convert them to png in bulk, for easy viewing.
#Run in /ClusteringRESULTS/

#Extract cluster centroids.pdbs from MasterPDB folder

for c in ./*CLUST_DATA
do
	cd "$c"
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
	cd ..
done



