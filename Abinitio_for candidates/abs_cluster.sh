#!/bin/bash
#Lrlrlr 160619 updated 200619 cluster_optimize.sh 301019 adapted for abs_cluster.sh
#cluster the candidates
#test on 5z1v- 1k_cv

#clean directory
rm *.pdb

#list models with scores below 0- take from scoretmalign.csv
awk '{if ($3 < 0) print $1, $2, $3, $4}' *.scoretmalign.csv > below0.scoretmalign	#filter for only values below 0
cat below0.scoretmalign | sed '/^$/d' | awk '{print $1".pdb"}' > PDBlistbelow0

#extract pdb of only below 0
tar xjf *pdb.tar.bz2 -T PDBlistbelow0

#run clustering using radius of 2.5
cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 2.5 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy -out:prefix cluster2 > cluster2.log
mkdir Cluster2
mv cluster2* Cluster2
rm cluster2*
echo "Cluster2 DONE!"

#cleanup
rm S_*pdb F_*pdb
mkdir Plots_clustering

#process for plotting
for d in ./Cluster*;
do
	cp below0.scoretmalign "$d"
	cd "$d"
	mkdir MasterPDB
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
	mv cluster.png $d.cluster.png
	mv plot_cluster $d.plot_cluster
	mv cluster_table $d.cluster_table
	cat *cluster_table | sort -nk 7 | tail -1 > $d.biggest
	cat *biggest | awk '{print $6}' > bigClus	#capture cluster number of biggest cluster
	awk 'BEGIN { while(getline <"bigClus") id[$0]=1; } id[$6] ' *.cluster_table	> $d.bigmember	#list pdb member in the biggest cluster
	cp *.biggest *cluster.png *plot_cluster *cluster_table *bigmember ../Plots_clustering
	tar -cjf $d.cluster.tar.bz2 cluster*pdb
	rm cluster*pdb bigClus
	cd ..
done

#cd Plots_clustering 
#cat *2.biggest *3.biggest *4.biggest *5.biggest *6.biggest > biggestCluster
#rm *.biggest
#cat Cluster2.bigmember | awk '{print $1}' > c2
#paste c2 c3 c4 c5 c6 | column -s $'\t' -t > table
#cd ..
##grep -f "c2" -v "c3" -find non matching of c2 with c3, remove -v for matching

#cleanup compress
for x in ./Cluster*
do
	cd "$x"
	cd MasterPDB
	tar -cjf masterpdb.tar.bz2 cluster*.pdb
	rm cluster*.pdb
	cd ../../
done

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
