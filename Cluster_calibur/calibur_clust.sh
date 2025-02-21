#!/bin/bash
#Lrlrlr 130319 calibur_clust.sh
#Usage: to cluster 10,000 decoys using Calibur. 
#Tagged with 10k_calibur.txt
#Input: silent.out, 10k_list.txt
#Output: calibur10k.out


#Extract all pdb file from several output files (not applicable to seperate single silent.out file)
score_jd2.default.linuxgccrelease --in:file:silent *.out --in:file:fullatom --out:pdb --out:file:fullatom --no_nstruct_label

#extract_pdbs.default.linuxgccrelease -in:file:silent silent.out -in:file:tagfile 10k_list.txt #cant use list, some score.fsc have mix of F and S output

#Run calibur clustering
calibur.default.linuxgccrelease -pdb_list 10k_calibur.txt > calibur10k.out
