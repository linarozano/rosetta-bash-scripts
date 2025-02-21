#!/bin/bash
#Lrlrlr 010419 recoverline1.sh >HanSolo<
#the first line have been deleted, need to be recovered

#BUG1- troubleshoot as #recoverline1.sh
#the first line have been deleted in list1k but not top1k.table, need to be recovered
#In each TMalign 1k folder have top1k.table
#only take the 1st line in each folder

for d in ./*; do (cd "$d" && cat top1k.table | head -1 | awk '{print $1".pdb"}' > $d.line1.txt ); done
for d in ./*; do (cd "$d" && tar xjf all_pdb.tar.bz2 -T $d.line1.txt); done 	#extract from this list
for d in ./*; do (cd "$d" && mkdir "$d"top1); done 	# file symbol is $d, folder symbol is "$d"
for d in ./*; do (cd "$d" && cp S* F* *line1.txt "$d"top1); done 
mkdir top1forall
for d in ./*; do (cd "$d" && cp -r "$d"top1 ../top1forall); done 


###ITs already in the magnus directory
