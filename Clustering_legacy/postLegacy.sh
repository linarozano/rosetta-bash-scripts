#!/bin/bash
#Lrlrlr 030320 postLegacy.sh
#simple post-analysis of legacy clustering output

#INPUT: *.centroids
#Only take top 30 centroids--this is still abundant

for x in ./Cluster*
do
	mkdir Top30Centroids
	cd "$x"
	cat *.centroids | awk '{if ($8 < 31) print $3".pdb", $4, $5, $8, $9, $1, $2}' > $x.top30C
	cat $x.top30C | awk '{print $1}' > $x.top30Cpdb
	cp $x.top30C $x.top30Cpdb ../Top30Centroids
	cd ..
done

#merge with tmscore with data
cd Top30Centroids

sed -i '1d' *plot_data2
for i in ./*pdb
do
	grep -f $i *plot_data2 > $i.tmscores
done

#quickfix for legacy clustering with alignment issues (cluster_table)
cat *cluster_table | awk '{print "S_"$5, $6, $7}' | sort -nk 2 > NEWclustertable
cat NEWclustertable | head -31 > TOP30clustertable

#LEGACY with 10% CUTOFF
sed -i '1d' *plot_data2
cat *plot_data2 | awk '{print $1".pdb", $2, $3}' | sort -nk 3 | head -1001 > 10percentdata
cat 10percentdata | awk '{print $1}' > 10percentPDB
tar xjf *pdb.tar.bz2 -T 10percentPDB
#clustering r2,3,4,5,6
#Clustering using legacy

cluster.default.linuxgccrelease -in:file:s S_*.pdb -in:file:fullatom -run:shuffle -cluster:radius 2.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy > cluster2.log
cluster.default.linuxgccrelease -in:file:s S_*.pdb -in:file:fullatom -run:shuffle -cluster:radius 3.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy > cluster3.log
cluster.default.linuxgccrelease -in:file:s S_*.pdb -in:file:fullatom -run:shuffle -cluster:radius 4.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy > cluster4.log
cluster.default.linuxgccrelease -in:file:s S_*.pdb -in:file:fullatom -run:shuffle -cluster:radius 5.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy > cluster5.log
cluster.default.linuxgccrelease -in:file:s S_*.pdb -in:file:fullatom -run:shuffle -cluster:radius 6.0 -cluster:limit_clusters -1 -cluster:sort_groups_by_energy > cluster6.log

#set as no output pdb
for x in ./cluster*.log
do
	sed -n '/.pdb  0  0/,/Timing:/p' $x > $x.oricluster #print lines between two patterns, contents in cluster output of the clusters
	sed -i -r 's/\S+//1' $x.oricluster
	sed -i -r 's/\S+//1' $x.oricluster
	cat $x.oricluster | awk '$3==0 {print}' > $x.centroids
done
rm S_*.pdb

