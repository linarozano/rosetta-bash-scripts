#!/bin/bash
#Lrlrlr 130319 appendList.sh
#Usage: to create correct list for calibur clustering
#Input: PDB list (no .pdb) (no path)

#Take the txt input file, open 

#Rename to add .pdb at the end and save as new file

awk '{print $0".pdb"}' testlist.txt > forcalibur.txt

#Run calibur clustering
calibur.default.linuxgccrelease -n -c A forcalibur.txt 4.0