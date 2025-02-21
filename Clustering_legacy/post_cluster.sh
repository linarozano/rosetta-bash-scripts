#!/bin/bash
#Lrlrlr 240719 post_cluster.sh
#To analyse clustering results of nstruct 1k-50k (independently)
#and select for the best rmsd/radius to use

#The directory to analyse. Example: 5zlvd/ClusteringRESULTS/
#Create new table rank based on biggest cluster and list of centroid and total number of members. (As in excel file prev.


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
	rm *temp
	cp *summary ../../
	cd ../../
done

mkdir CentroidSUM
mv *.summary CentroidSUM
cd CentroidSUM
#concatenate file with header seperator
tail -n +1  1k*summary 2p*summary 5k*summary 7p*summary 10k*summary 20*summary 30*summary 40*summary 50*summary > ClusterSummary
mv ClusterSummary ../
