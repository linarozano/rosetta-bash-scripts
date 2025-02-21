#!/bin/bash
#Lrlrlr 141019 abs.sh updated 301019- non-native mode updated 130120 updated 130220 abs_candyV2.sh
#Post processing of abinitio runs, script to run rosetta abinitio on a candidate with no known native.pdb

#extract and backup from output results
score_jd2.default.linuxgccrelease --in:file:silent *.out --in:file:fullatom --out:pdb --out:file:fullatom --no_nstruct_label	#compress pdbs
tar -cjf extracted.pdb.tar.bz2 F_* S_*

#compress out files
tar -cjvf results.outs.tar.bz2 *.out
rm *.out

#A. Process only data with score below 0 (only take ID and score) ---an independent process
awk '{if ($2 < 0) print $NF, $2}' *.fsc > below0.score #depends on the results, might have more or less results
cat below0.score | sort -nk 2 | head -20 > temp20 #pdb to be extracted and placed in quickview
cat temp20 | sed '/^$/d' | awk '{print $1".pdb"}' > top20list	#put pdb extension for extraction from ori tar file
cat below0.score | sed '/^$/d' | awk '{print $1".pdb"}' > PDBlistbelow0	#put pdb extension for extraction from ori tar file
rm temp*

#copy Top20
mkdir Top20
xargs -a top20list cp -t Top20

#B. Clustering
mkdir Cluster_output
xargs -a PDBlistbelow0 mv -t Cluster_output
rm F_* S_* 	#cleanup

#Clustering using legacy
cd Cluster_output
cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 3.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy -out:prefix cluster3 > cluster3.log
mkdir Centroids
cp *.0.pdb Centroids	
tar -cjvf Cluster3.pdb.tar.bz2 cluster3c* #compress the members
rm cluster3c*

sed -n '/.pdb  0  0/,/Timing:/p' cluster*.log > oricluster3 #print lines between two patterns, contents in cluster output of the clusters
sed -i -r 's/\S+//1' oricluster3
sed -i -r 's/\S+//1' oricluster3
cat oricluster3 | awk '$3==0 {print}' > listCentroids
cd ..
