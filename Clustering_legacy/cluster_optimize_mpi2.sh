#!/bin/bash
#Lrlrlr 160619 updated 250719 cluster_optimize.sh
#optimize the clustering of predicted models
#test on 5z1v- 1k_cv

#clean directory
rm *.pdb

#list models with scores below 0- take from scoretmalign.csv
awk '{if ($3 < 0) print $1, $2, $3, $4}' *.scoretmalign.csv > below0.scoretmalign	#filter for only values below 0
cat below0.scoretmalign | sed '/^$/d' | awk '{print $1".pdb"}' > PDBlistbelow0

#extract pdb of only below 0
tar xjf *pdb.tar.bz2 -T PDBlistbelow0

#run clustering using radius of 2,3,4,5,6
cluster.mpi.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 2.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy -out:prefix cluster2 > cluster2.log
mkdir Cluster2
mv cluster2* Cluster2
rm cluster2*
echo "Cluster2 DONE!"