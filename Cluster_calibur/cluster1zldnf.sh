#!/bin/bash
#Lrlrlr 060419 cluster1zldnf.sh
#Testing different parameters for 1zld_nff

#Evoke sbatch of clustering based on different param default mode
#cd legacy_05nf && cluster.default.linuxgccrelease -in:file:s /scratch/pawsey0110/lrozano/Cluster_legacy/1zld_nff/*.pdb -in:file:fullatom -run:shuffle -cluster:radius 0.5 > cluster05nf.log
cd legacy_1nf && cluster.default.linuxgccrelease -in:file:s /scratch/pawsey0110/lrozano/Cluster_legacy/1zld_nff/*.pdb -in:file:fullatom -run:shuffle -cluster:radius 1.0 > cluster1nf.log
cd ..
cd legacy_2nf && cluster.default.linuxgccrelease -in:file:s /scratch/pawsey0110/lrozano/Cluster_legacy/1zld_nff/*.pdb -in:file:fullatom -run:shuffle -cluster:radius 2.0 > cluster2nf.log
cd ..
cd legacy_3nf && cluster.default.linuxgccrelease -in:file:s /scratch/pawsey0110/lrozano/Cluster_legacy/1zld_nff/*.pdb -in:file:fullatom -run:shuffle -cluster:radius 3.0 > cluster3nf.log
cd ..
cd legacy_4nf && cluster.default.linuxgccrelease -in:file:s /scratch/pawsey0110/lrozano/Cluster_legacy/1zld_nff/*.pdb -in:file:fullatom -run:shuffle -cluster:radius 4.0 > cluster4nf.log

