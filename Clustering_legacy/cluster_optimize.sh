#!/bin/bash
#Lrlrlr 160619 updated 200619 cluster_optimize.sh updated 101119
#optimize the clustering of predicted models
#test on 5z1v- 1k_cv
#Will be copied into each *_cv folders using clustercopy.sh and will run in each *_cv folders.

#list models with scores below 0- take from scoretmalign.csv
awk '{if ($3 < 0) print $1, $2, $3, $4}' *.scoretmalign.csv > below0.scoretmalign	#filter for only values below 0
cat below0.scoretmalign | sed '/^$/d' | awk '{print $1".pdb"}' > PDBlistbelow0

#extract pdb of only below 0
tar xjf *pdb.tar.bz2 -T PDBlistbelow0

#run clustering using radius of 2,3,4,5,6
cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 2.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy -out:prefix cluster2 > cluster2.log
mkdir Cluster2
mv cluster2* Cluster2
rm cluster2*
echo "Cluster2 DONE!"

cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 3.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy -out:prefix cluster3 > cluster3.log
mkdir Cluster3
mv cluster3* Cluster3
rm cluster3*
echo "Cluster3 DONE!"

cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 4.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy -out:prefix cluster4 > cluster4.log
mkdir Cluster4
mv cluster4* Cluster4
rm cluster4*
echo "Cluster4 DONE!"

cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 5.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy -out:prefix cluster5 > cluster5.log
mkdir Cluster5
mv cluster5* Cluster5
rm cluster5*
echo "Cluster5 DONE!"

cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 6.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy -out:prefix cluster6 > cluster6.log
mkdir Cluster6
mv cluster6* Cluster6
rm cluster6*
echo "Cluster6 DONE!"

#cleanup
rm S_*pdb F_*pdb
mkdir Plots_clustering

#process for plotting
for d in ./Cluster*;
do
	cp below0.scoretmalign "$d"
	cd "$d"
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

cd Plots_clustering 
cat *2.biggest *3.biggest *4.biggest *5.biggest *6.biggest > biggestCluster
rm *.biggest

cat Cluster2.bigmember | awk '{print $1}' > c2
cat Cluster3.bigmember | awk '{print $1}' > c3
cat Cluster4.bigmember | awk '{print $1}' > c4
cat Cluster5.bigmember | awk '{print $1}' > c5
cat Cluster6.bigmember | awk '{print $1}' > c6

paste c2 c3 c4 c5 c6 | column -s $'\t' -t > table

#grep -f "c2" -v "c3" -find non matching of c2 with c3, remove -v for matching

#cleanup compress
for x in ./Cluster*
do
	cd "$x"
	cd MasterPDB
	tar -cjf masterpdb.tar.bz2 cluster*.pdb
	rm cluster*.pdb
	cd ../../
done


