#!/bin/bash
#Bash script to list and extract PDB files of top1k scores from Rosetta abinitio output based on the standard rosetta scoring function ref2015
#Input: silent output files (.out) and score.fsc #3Options
#Output: top1k_pdbs folder containing extracted pdbs and table
#Lrlrlr 300319 top1k_pdb2.sh (HanSolo)

#In parent directory containing sub-directories containing silent.out and score.fsc
#Make a list of what to be extracted
for d in ./*; do (cd "$d" && cat *.fsc | awk '{print $NF"\t"$27"\t" $2}' | sort -nk 3 | head -1001 > top1k.table ); done		#top 1k of 3 column

for d in ./*; do (cd "$d" && cat top1k.table | awk '{print $1".pdb"}' > list1k.txt); done		#Option 1, only the id line(have .pdb) #1st header is being deleted by seed 1d
#for d in ./*; do (cd "$d" && cat top1k.table | awk '{print $1}' > list1k.txt); done		#Option 2 (do not have .pdb)

#Option 1- step1 extract from tar.bz2 file
for d in ./*; do (cd "$d" && tar xjf all_pdb.tar.bz2); done

#Option1- step 2 copy extracted pdbs into seperate folders 
for d in ./*; do (cd "$d" && mkdir "$d"_1k); done
for d in ./*; do (cd "$d" && xargs -a list1k.txt cp -t "$d"_1k); done
for d in ./*; do (cd "$d" && cp top1k.table "$d"_1k); done

#Option2- extract from silent.out (extract_pdbs.not working)
#for d in ./*; do (cd "$d" && extract_pdbs.default.linuxgccrelease -in:file:silent *out -in:file:tagfile list1k.txt -out:pdb -out:file:fullatom); done
#score_jd2.default.linuxgccrelease -in:file:silent silent.out -in:file:fullatom 
#score_jd2.default.linuxgccrelease --in:file:silent *.out --in:file:fullatom --out:pdb --out:file:fullatom --no_nstruct_label --in:file:tagfile list1k.txt

#Compile all in one folder
mkdir 1k_pdb_toxa1
for d in ./*; do (cd "$d" && mv "$d"_1k ../1k_pdb_toxa1); done

#top1k.table can be used to combine with tmalign.csv in superpose.sh

#BUG1- troubleshoot as #recoverline1.sh
#the first line have been deleted in list1k but not top1k.table, need to be recovered
#In each TMalign 1k folder have top1k.table
#only take the 1st line in each folder

for d in ./*; do (cd "$d" && cat top1k.table | head -1 | awk '{print $1".pdb"}' > $d.line1.txt ); done
for d in ./*; do (cd "$d" && tar xjf all_pdb.tar.bz2 -T $d.line1.txt); done 	#extract from this list
for d in ./*; do (cd "$d" && mkdir top1$d); done 
for d in ./*; do (cd "$d" && cp S* F* *line1.txt top1$d); done 
mkdir top1forall
for d in ./*; do (cd "$d" && cp top1$d ../top1forall); done 


###ITs already in the magnus directory
#extract only one from tar file. tar xjf all_pdb.tar.bz2 S_00007218.pdb




