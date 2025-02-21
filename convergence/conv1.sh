#!/bin/bash
#Lrlrlr 290519 conv1.sh
#script to manage output data and process outputs for convergence test
#will have in 3 continuous version from magnus to zeus.
#run on nstruct*_cv folders

#on MAGNUS
#compile score.fsc into new folder
mkdir combined_scorefsc
for d in ./*_cv
do
	cd "$d"
	mv score.fsc $d.score.fsc
	cp *.score.fsc ../combined_scorefsc
	cd ..
done

#extract pdbs in each folder from multiple results_*out files
#>compress extracted pdbs in $d.tar.bz2
#>delete extracted pdbs
mkdir combined_tarbz2
for d in ./*_cv
do 
	cd "$d"
	score_jd2.default.linuxgccrelease --in:file:silent *.out --in:file:fullatom --out:pdb --out:file:fullatom --no_nstruct_label	#extract pdbs
	tar -cjf $d.pdb.tar.bz2 F_* S_*
	rm F_* S_*
	cp *.pdb.tar.bz2 ../combined_tarbz2
	cd ..
done

#compile resultsout
mkdir combined_resultsout
for d in ./*_cv
do
	cd "$d"
	tar -cjf $d.outs.tar.bz2 results_*.out
	rm results_*.out 
	cp *.outs.tar.bz2 ../combined_resultsout
	cd ..
done
	

