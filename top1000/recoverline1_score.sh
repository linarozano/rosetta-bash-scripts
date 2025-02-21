#!/bin/bash
#Lrlrlr 040419 recoverline1score.sh >HanSolo<
#the first line have been deleted, need to be recovered- with the scores

#continuation of #recoverline1.sh


for d in ./*; do (cd "$d" && cat top1k.table | head -1 | awk '{print $1, $NF}' > $d.line1score.txt ); done

mkdir line1score

for d in ./*; do cp $d/*.line1score.txt line1score; done;		

cat *.line1score.txt > allline1score.txt

#recover pdb of 1st in each max for tmalign. to get rmsd for all
#for d in ./*; do (cd "$d" && cp S*.pdb ../PDBtop1max); done

