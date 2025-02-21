#!/bin/bash
#Lrlrlr 160619 updated 200619 cluster_optimize.sh updated 101119
#optimize the clustering of predicted models
#test on 5z1v- 1k_cv
#Will be copied into each *_cv folders using clustercopy.sh and will run in each *_cv folders.

#list models with scores below 0- take from scoretmalign.csv
awk '{if ($3 < 0) print $1, $2, $3, $4}' *.scoretmalign.csv > below0.scoretmalign	#filter for only values below 0
cat below0.scoretmalign | sed '/^$/d' | awk '{print $1".pdb"}' > PDBlistbelow0

#extract pdb of only below 0
tar xjf *tar.bz2 -T PDBlistbelow0

#run clustering using radius of 3

cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 3.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy true -out:prefix cluster3 > cluster3.log

#cleanup
rm S_*pdb F_*pdb
mkdir Plots_clustering

#process for plotting
mkdir MasterPDB	#will store all the extracted centroids
mv *.0.pdb MasterPDB
sed -n '/.pdb  0  0/,/Timing:/p' cluster*.log > temp_cluster1 #print lines between two patterns, contents in cluster output of the clusters
cut -d '_' -f 2 temp_cluster1 > temp_cluster2
cat temp_cluster2 | sort -nk 1 | sed '1d' > temp_merge	#remove 1st line containing Timing:
paste below0.scoretmalign temp_merge | column -s $'\t' -t > cluster_table
cat cluster_table | awk '{print $2, $3, $6}' > plot_cluster
rm temp*
gnuplot -persist <<-EOFMarker
	set term png 	#will produce png output
	set output 'cluster.png'	#output filename
	set title 'score_vs_rmsd'
	set xlabel 'rmsd'
	set ylabel 'score'
	set timestamp
	plot 'plot_cluster' with points palette		#plot column 2 (rms_core) vs 3 (score)	
EOFMarker
mv cluster.png 10k.cluster.png
mv plot_cluster 10k.plot_cluster
mv cluster_table 10k.cluster_table

cat *cluster_table | sort -nk 7 | tail -1 > 10k.biggest
cat *biggest | awk '{print $6}' > bigClus	#capture cluster number of biggest cluster
awk 'BEGIN { while(getline <"bigClus") id[$0]=1; } id[$6] ' *.cluster_table	> 10k.bigmember	#list pdb member in the biggest cluster
cp *.biggest *cluster.png *plot_cluster *cluster_table *bigmember Plots_clustering
tar -cjf 10k.cluster.tar.bz2 cluster*pdb
rm cluster*pdb bigClus

cat *bigmember | awk '{print $1}' > c2

#grep -f "c2" -v "c3" -find non matching of c2 with c3, remove -v for matching

#cleanup compress
cd MasterPDB
tar -cjf masterpdb.tar.bz2 cluster*.pdb
rm cluster*.pdb


