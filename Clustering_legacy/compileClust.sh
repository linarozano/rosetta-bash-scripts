#!/bin/bash
#Lrlrlr compileClust.sh
#to compile clustering results so its easy to backup Clustering results on Rdrive

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


	