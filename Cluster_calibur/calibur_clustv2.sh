 #!/bin/bash
#Lrlrlr 130319 udsated 280719 calibur_clustv2.sh
#Usage: to cluster 10,000 decoys using Calibur. 
#Tagged with 10k_calibur.txt
#Input: silent.out, 10k_list.txt
#Output: calibur10k.out
#Run in directory ./Clustering/1zld/1k_cv
#only have one mode and combine with results analysis. Plus post calibur 

mkdir CaliburRESULTS
for d in ./*_cv
do
	cd "$d"
	rm *pdb
	tar xjf *pdb.tar.bz2 -T PDBlistbelow0
	calibur.default.linuxgccrelease -pdb_list PDBlistbelow0 > $d.calibur
	cat *.calibur | grep "Largest" > $d.temp
	cp *.calibur *.temp ../CaliburRESULTS
	rm *pdb	*temp #cleanup
	cd ..
done

#compile results
cd CaliburRESULTS
tail -n +1 1k*temp 2p*temp 5k*temp 7p*temp 10*temp 20*temp 30*temp 40*temp 50*temp > CaliburSummary
rm *.temp

#capture members
for x in ./*.calibur
do
	cat *_cv.calibur | grep "Finding and removing" -A 50000 > $x.members
done
