#!/bin/bash
#Lrlrlr 280719 post_calibur.sh
#will be integrated with calibur_clustv2.sh
#Run under /1zld/.

mkdir CaliburRESULTS
for d in ./*_cv
do
	cd "$d"
	cat *.calibur | grep "Largest" > $d.temp
	cp *.calibur *.temp ../CaliburRESULTS
	rm *.temp
	cd ..
done

cd CaliburRESULTS
tail -n +1 1k*temp 2p*temp 5k*temp 7p*temp 10*temp 20*temp 30*temp 40*temp 50*temp > CaliburSummary
rm *.temp

#capture members
for x in ./*.calibur
do
	cat *_cv.calibur | grep "Finding and removing" -A 50000 > $x.members
done

