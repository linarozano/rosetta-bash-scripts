#!/bin/bash
#Lrlrlr 290519 conv2.sh updated 161019 to conv2v2.sh
#to calculate RMSD, tmscore and tmalign of decoys with native.pdb
#on ZEUS- run on the same directory as on MAGNUS conv1.sh
#final: decommpress extracted pdbs

#make sure native.pdb is the parent directory
#Copy native.pdb to each *_cv folder
#MERGE with 
#Lrlrlr 020619 copytofolders.sh
#run in parent directory containing 10k_cv, 1k_cv ...etc

#run tmalign and tmscore
#only run 1st stage of TMalign- no superposed rslt -o TM.sup_atm TM.sup_all_atm

for d in ./*_cv
do
	cp native.pdb "$d"
	cd "$d"	
	tar xjf *.pdb.tar.bz2	#decompress
	ls *.pdb > list #create list of all pdbs for maxcluster
	for x in ./*.pdb 	
	do 
		TMalign "$x" native.pdb > $x.tmalign	#calculate tmalign using native pdb as reference
		pdbrmsd native.pdb "$x" > $x.rmsd	#calculate normal rmsd using native pdb as reference
	done
	maxcluster64bit -e native.pdb -l list -rmsd -nosort > maxrmsd #run maxcluster rmsd calculation- do not sort based on rmsd, in reverse
	cat maxrmsd | awk '{print $6, $7}' > temp.maxrmsd #capture only id and rmsd
	sed -i '1,5d' temp.maxrmsd #remove the first 5 lines from temp.maxrmsd	
	rm S_*.pdb F_*.pdb	#cleanup: delete all extracted pdbs S_ and F_
	mkdir TMalign_data	#new folder to store TMalign data
	cp *.tmalign TMalign_data/	#create backup copy of each .tmalign data of each models for future reference
	tar -cjf $d.tmalign.tar.bz2 TMalign_data	#compress TMalign_data
	rm -r TMalign_data	#cleanup: delete after compress original folder
	cat *.tmalign > tmalign.log	#concatenate all tm files into tmalign.log
	rm *.tmalign #cleanup: remove single tmalign log for all pdbs
	cat *.rmsd > combinermsd 
	rm *.rmsd 
	cat combinermsd | grep -o -P '(?<=RMSD:).*(?=)' > capturermsd	#capture only rmsd value 
	sed -i "s/ //g" capturermsd 	#remove whitespace in file
	cat tmalign.log | grep -o -P '(?<=./).*(?=.pdb)' > id.log		#Start creating data for tmalign.csv, capture only id value of decoys
	sed -i "s/ //g" id.log 	#remove whitespace in file
	cat tmalign.log | grep -o -P '(?<=RMSD=).*(?=,)' > rmsd.log		#capture only rmsd value 
	sed -i "s/ //g" rmsd.log 	#remove whitespace in file
	cat tmalign.log | grep -o -P '(?<=TM-score=).*(?=if normalized by length of Chain_2)' > tmscore.temp		#capture TMscore value normalized by length of the reference protein
	sed 's/(//' tmscore.temp > tmscore.log  #remove unwanted character in tmscore value
	sed -i "s/ //g" tmscore.log 	#remove whitespace in file
	paste id.log rmsd.log tmscore.log capturermsd | column -s $'\t' -t > tmalign.csv	#create tmalign.csv file #match rmsd value with models id
	rm id.log rmsd.log tmscore.log tmscore.temp
	cd ..	#go back to parent directory, and run other folders
done 

#calculate normal rmsd using pdbremix function- will have re-rextract all pdbs and calculate #better to integrate with tmalign script
#MERGE with 
#Lrlrlr 050819 evaluation_plot_withnewrmsd.sh edited 270919 for RL_case
#Input: *.pdb.tar.bz2 and score.fasc
#maxcluster
#maxcluster64bit native.pdb S_00004501.pdb -rmsd





