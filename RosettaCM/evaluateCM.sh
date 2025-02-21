#!/bin/bash
#Lrlrlr 090619 evaluateCM.sh
#run tmalign with native and plot score vs rmsd
#custom for rosettaCM- adapted from convergence abinitio scripts

#on ZEUS- run on the same directory as on MAGNUS conv1.sh
#run in folder output_hybridize
mkdir top10_pdb
mv S_* top10pdb top10_pdb/

tar xjf pdb.tar.bz2	#decompress
for x in ./*.pdb 	
do 
	TMalign "$x" native.pdb > $x.tmalign	#calculate tmalign using native pdb as reference
done
rm S_*.pdb #cleanup
mkdir TMalign_data	#new folder to store TMalign data
cp *.tmalign TMalign_data/	#create backup copy of each .tmalign data of each models for future reference
tar -cjf tmalign.tar.bz2 TMalign_data	#compress TMalign_data
rm -r TMalign_data	#cleanup: delete after compress original folder
cat *.tmalign > tmalign.log	#concatenate all tm files into tmalign.log
rm *.tmalign #cleanup: remove single tmalign log for all pdbs
cat tmalign.log | grep -o -P '(?<=./).*(?=.pdb)' > id.log		#Start creating data for tmalign.csv, capture only id value 
sed -i "s/ //g" id.log 	#remove whitespace in file
cat tmalign.log | grep -o -P '(?<=RMSD=).*(?=,)' > rmsd.log		#capture only rmsd value 
sed -i "s/ //g" rmsd.log 	#remove whitespace in file
paste id.log rmsd.log | column -s $'\t' -t > tmalign.csv	#create tmalign.csv file #match rmsd value with models id
rm id.log rmsd.log

