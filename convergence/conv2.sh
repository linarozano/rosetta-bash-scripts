#!/bin/bash
#Lrlrlr 290519 conv2.sh
#script to manage output data and process outputs for convergence test
#will have in 2 continuous version from magnus to zeus.
#only run 1st stage of TMalign- no superposed rslt -o TM.sup_atm TM.sup_all_atm

#on ZEUS- run on the same directory as on MAGNUS conv1.sh
#if i want to use ZEUS, will burn quota there
#make sure native.pdb is the parent directory
#>decommpress extracted pdbs

for d in ./*_cv
do 
	cp native.pdb "$d"
	cd "$d"	
	tar xjf *.pdb.tar.bz2	#decompress
	for x in ./*.pdb 	
	do 
		TMalign "$x" native.pdb > $x.tmalign	#calculate tmalign using native pdb as reference
	done
	rm S_*.pdb F_*.pdb	#cleanup: delete all extracted pdbs S_ and F_
	mkdir TMalign_data	#new folder to store TMalign data
	cp *.tmalign TMalign_data/	#create backup copy of each .tmalign data of each models for future reference
	tar -cjf $d.tmalign.tar.bz2 TMalign_data	#compress TMalign_data
	rm -r TMalign_data	#cleanup: delete after compress original folder
	cat *.tmalign > tmalign.log	#concatenate all tm files into tmalign.log
	rm *.tmalign #cleanup: remove single tmalign log for all pdbs
	cat tmalign.log | grep -o -P '(?<=./).*(?=.pdb)' > id.log		#Start creating data for tmalign.csv, capture only id value 
	sed -i "s/ //g" id.log 	#remove whitespace in file
	cat tmalign.log | grep -o -P '(?<=RMSD=).*(?=,)' > rmsd.log		#capture only rmsd value 
	sed -i "s/ //g" rmsd.log 	#remove whitespace in file
	paste id.log rmsd.log | column -s $'\t' -t > tmalign.csv	#create tmalign.csv file #match rmsd value with models id
	rm id.log rmsd.log
	cd ..	#go back to parent directory, and run other folders
done 






