#!/bin/bash
#Lrlrlr 160619 postclus.sh
#to analyse cluster.log data sort into table and plot based on clusters

#determine the best radius for clustering which will generate cluster of approx 100-150
#different family will have different clustering radius
#run in ClusterOUTPUT directory

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
