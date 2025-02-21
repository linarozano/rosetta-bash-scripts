#!/bin/bash
#Bash script to list and extract PDB files of top1k scores from Rosetta abinitio output based on the standard rosetta scoring function ref2015
#Input: silent output files (.out)
#Output: top1k_pdbs folder containing top50_scores.txt, top50_pdb.txt, top 50 PDB files
#Lrlrlr 300319 top1k_PDB1.sh
#Usage: sh list_and_extractPDB.sh, run in directory containing silent output files
#Requirements: Rosetta installed and $PATH set to ./ROSETTA_VERSION/main/source/bin

#First rank top 1000 based on rosetta scores
for d in ./*; do cat $d | sort -nk 3 | head -1000 > $d.log; done		#create 1k.log for each files

#Extract only PDB name starting from S and F_.pdb
for d in ./*.log; do cat $d | awk '{print $1}' > $d.txt; done

mkdir PDB_list
mkdir Scores
mv *.log Scores/
mv *.txt PDB_list/


#Extract top 50 PDB files from the Rosetta silent output files
#echo "extracting top 1000 PDBs"
#extract_pdbs.default.linuxgccrelease -in:file:silent *out -in:file:tagfile top1k_pdb.txt

#Creating new folder top50_pdb and moving outputs into folder
#echo "Creating new folder, because we can"
#mkdir top1k_pdbs
#mv *pdb *txt top1k_pdbs
#echo "Top 1000 PDB files have been extracted and can be found in top1k_pdbs folder"
#exit
