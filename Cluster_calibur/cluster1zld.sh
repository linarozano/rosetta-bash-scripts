#!/bin/bash
#Lrlrlr 060419 cluster1zld.sh
#Testing different parameters for 1zld

#Evoke sbatch of clustering based on different param default mode
#error because no continuation- so insert cd ..

#cd legacy_05 && cluster.default.linuxgccrelease -in:file:s /scratch/pawsey0110/lrozano/Cluster_legacy/1zld_2/*.pdb -in:file:fullatom -run:shuffle -cluster:radius 0.5 > cluster05.log
#cd ..
cd legacy_1 && cluster.default.linuxgccrelease -in:file:s /scratch/pawsey0110/lrozano/Cluster_legacy/1zld_2/*.pdb -in:file:fullatom -run:shuffle -cluster:radius 1.0 > cluster1.log
cd ..
cd legacy_2 && cluster.default.linuxgccrelease -in:file:s /scratch/pawsey0110/lrozano/Cluster_legacy/1zld_2/*.pdb -in:file:fullatom -run:shuffle -cluster:radius 2.0 > cluster2.log
cd ..
cd legacy_3 && cluster.default.linuxgccrelease -in:file:s /scratch/pawsey0110/lrozano/Cluster_legacy/1zld_2/*.pdb -in:file:fullatom -run:shuffle -cluster:radius 3.0 > cluster3.log
cd ..
cd legacy_4 && cluster.default.linuxgccrelease -in:file:s /scratch/pawsey0110/lrozano/Cluster_legacy/1zld_2/*.pdb -in:file:fullatom -run:shuffle -cluster:radius 4.0 > cluster4.log
cd ..

