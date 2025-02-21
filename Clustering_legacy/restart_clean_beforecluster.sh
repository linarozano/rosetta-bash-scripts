#!/bin/bash
#Lrlrlr 101119
#To reset folder to contain only files required for clustering
#Run script in parent directory containing the subdirectories


#cleanup unused folders and files
rm -r best* combined_* convergence_plot* evaluation_plots scoretmalign #remove previous folders from conv2 and conv3 runs
rm aat000* *err *log *tar.bz2 native*

for d in ./*_cv
do 
	cd "$d" 
	rm -r Cluster* Plots_clustering PDB*
	GLOBIGNORE=*.pdb.tar.bz2:*scoretmalign.csv
	rm -v *
	unset GLOBIGNORE
	cd ..
done

