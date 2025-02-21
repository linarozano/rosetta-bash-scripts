#!/bin/bash
#Lrlrlr 160619 clustering.sh
#to cluster predicted models

#based on JH script
#create the best 5 models clustered/averaged from 25000 abinitio models
#cluster *.0.0.pdb is the best model based on lowest energy score (most stable) and is the one we will use further on for docking predictions #this is wrong

#clean directory
rm *.pdb

#extract fresh pdb
tar xjf *pdb.tar.bz2 

#run clustering
cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 6.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy -out:prefix cluster6 > cluster6.log

#cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -cluster:limit_clusters 5 -cluster:sort_groups_by_energy -out:prefix 5cluster > 5cluster.log

rm S_*pdb F_*pdb
mkdir ClusterOUTPUT
mv cluster6* ClusterOUTPUT
cp *.scoretmalign.csv ClusterOUTPUT

cd ClusterOUTPUT
mkdir TopPDB_cluster
mv *.0.pdb TopPDB_cluster

#INPUT
#copy contents from .. until .. based on line

sed -n '/.pdb  0  0/,/Timing:/p' cluster*.log > temp_cluster1 #print lines between two patterns, contents in cluster output of the clusters

#treat as column, will have 5 columns
#arrange column 
cut -d '_' -f 2 temp_cluster1 > temp_cluster2

cat temp_cluster2 | sort -nk 1 | sed '1d' > temp_merge	#remove 1st line containing Timing:

#*.scoretmalign.csv already sorted based on number
paste *.scoretmalign.csv temp_merge | column -s $'\t' -t > cluster_table
cat cluster_table | awk '{print $2, $3, $6}' > plot_cluster
rm temp*

#PLOTS
#evaluation plot of score vs rmsd in xy scatterplots
#plot clusters based on colors using palette
gnuplot -persist <<-EOFMarker
	set term png 	#will produce png output
	set output 'cluster.png'	#output filename
	set title 'score_vs_rmsd'
	set xlabel 'rmsd'
	set ylabel 'score'
	set timestamp
	plot 'plot_cluster' with points palette		#plot column 2 (rms_core) vs 3 (score)	
EOFMarker


#plots for values below 0
awk '{if ($3 < 0) print $2, $3, $6}' cluster_table > plot_cluster2	#filter for only values below 0
gnuplot -persist <<-EOFMarker
	set term png 	#will produce png output
	set output 'cluster2.png'	#output filename
	set title 'score<0_vs_rmsd'
	set xlabel 'rmsd'
	set ylabel 'score'
	set timestamp
	plot 'plot_cluster2' with points palette	#plot column 2 (rms_core) vs 3 (score)	
EOFMarker

#cleanup
tar -cjf cluster.tar.bz2 cluster*pdb
rm cluster*pdb

