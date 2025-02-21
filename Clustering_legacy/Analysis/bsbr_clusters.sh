#!/bin/bash
#Lrlrlr 110719 bsbr_clusters.sh
#find in each cluster; the best score and the best rmsd
#save the pdb in a list- will have 2 lists

#for each content it column 6, rank the best score (column 3) and best rmsd (column 2)
#total number of clusters: find unique for column 6

awk '{ a[$6]++ } END { for (b in a) { print b } }' Cluster5.cluster_table > column6

