#!/bin/bash
#Lrlrlr 040419 cluster1.sh
#Run clustering using Rosetta's default cluster application

#copy only S*.pdb F*.pdb
#since there are also native pdb and template pdb (dont want this in to be clustered too)
#will use path /home/lrozano/Desktop/Cluster_legacyLB/1zld_2

#remove all file except
shopt -s extglob
rm -i !(*.zip)
rm -v !(S*.pdb|F*.pdb)
shopt -u extglob

cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -out:file:silent -run:shuffle -cluster:radius 3.0 > cluster3.log

#directory of pdbs
/scratch/pawsey0110/lrozano/Cluster_legacy/1zld_nff
/scratch/pawsey0110/lrozano/Cluster_legacy/1zld_2

#options:
1)1zld_2:
default xsort energy: 0.5, 1, 2, 3, 4 submitted
withsort energy: 0.5, 1, 2, 3, 4

2)1zld_nff:
default xsort energy: 0.5, 1, 2, 3, 4 submitted
withsort energy: 0.5, 1, 2, 3, 4

#with extracted pdbs
cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 2.0 -cluster:sort_groups_by_energy > cluster2.log
cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 1.0 -cluster:sort_groups_by_energy > cluster1.log
cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 0.5 -cluster:sort_groups_by_energy > cluster05.log

cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 2.0 > cluster2n.log
cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 1.0 > cluster1n.log
cluster.default.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 0.5 > cluster05n.log

#ERROR
-out:file:silent not working!!

#Linuxbox
cluster.static.linuxgccrelease -in:file:s *.pdb -in:file:fullatom -run:shuffle -cluster:radius 3.0 -cluster:sort_groups_by_energy  > cluster.log
cluster.static.linuxgccrelease -in:file:s /home/lrozano/Desktop/Cluster_legacyLB/1zld/*.pdb -in:file:fullatom -run:shuffle -cluster:radius 3.0 > cluster3.log

#time, 1.0 1hr; 

-database                 Path to rosetta databases
 -in:file:s                Input pdb file(s)
 -in:file:silent           Input silent file
 -in:file:fullatom         Read as fullatom input structure
 -out:file:silent          Output silent structures instead of PDBs
 -score:weights            Supply a different weights file (default is score12)
 -score:patch              Supply a different patch file (default is score12)
 -run:shuffle              Use shuffle mode
 
-cluster:radius  <float>                    Cluster radius in A (for RMS clustering) or in inverse GDT_TS for GDT clustering. Use "-1" to trigger automatic radius detection
   -cluster:gdtmm                              Cluster by gdtmm instead of rms
   -cluster:input_score_filter  <float>        Ignore structures above certain energy
   -cluster:exclude_res <int> [<int> <int> ..] Exclude residue numbers from structural comparisons
   -cluster:radius        <float>              Cluster radius
   -cluster:limit_cluster_size      <int>      Maximal cluster size
   -cluster:limit_clusters          <int>      Maximal number of clusters
   -cluster:limit_total_structures  <int>      Maximal number of structures in total
   -cluster:sort_groups_by_energy              Sort clusters by energy.

#Energy_based_clustering (not in rosetta package?)

energy_based_clustering.default.linuxgccrelease -in:file:silent silent.out -in:file:fullatom -cluster:energy_based_clustering:cluster_radius 1.0 -cluster:energy_based_clustering:silent_output

#flags
-in:file:silent inputs/backbones.silent
-in:file:fullatom
-cluster:energy_based_clustering:cluster_radius 1.0
-cluster:energy_based_clustering:limit_structures_per_cluster 10
-cluster:energy_based_clustering:cluster_by bb_cartesian
-cluster:energy_based_clustering:use_CB false
-cluster:energy_based_clustering:cyclic true
-cluster:energy_based_clustering:cluster_cyclic_permutations true

