#!/bin/bash
#Lrlrlr 141019 abs.sh updated 301019- non-native mode
#The ultimate script to run rosetta abinitio on a candidate with no known native.pdb
#CONSTRAINTS: depends.

#Steps to deploy. Its not possible to run all in one script since per job submission is 24 hours. 
#The 1st step of abinitio will need 24 hours.


#POST ABINITIO
#1. Whatever it is, run extract and compress first. --Can be saved as BACKUP
#Lrlrlr 050919 extractpdb_andcompress.sh

#score_jd2.default.linuxgccrelease --in:file:silent *.out --in:file:fullatom --out:pdb --out:file:fullatom --no_nstruct_label	#extract pdbs
#tar -cjf extracted.pdb.tar.bz2 F_* S_*
#rm F_* S_*

#compress out files
#tar -cjvf results.outs.tar.bz2 *.out
#rm *.out

#2. Run rmsd calculation using maxcluster
#non-native mode
#selecting ref pdb with best score
cat *.fsc | awk '{print $NF, $2}' | sort -nk 2 | head -1 > topidscore
cat topidscore | sed '/^$/d' | awk '{print $1".pdb"}' > nativelist  #delete empty line and append with ending of .pdb
tar xjf *pdb.tar.bz2 -T nativelist #untar pdb of nativelist from pdb.tar.bz2 file
mv S*pdb native.pdb #sure that the best score will start with S_

tar xjf *pdb.tar.bz2	#decompress
ls *.pdb > list #create list of all pdbs for maxcluster 10,001
maxcluster64bit -e native.pdb -l list -rmsd -nosort > maxrmsd.log #run maxcluster rmsd calculation- do not sort based on rmsd, in reverse
rm S_*.pdb F_*.pdb	#cleanup: delete all extracted pdbs S_ and F_
cat maxrmsd.log | awk '{print $6}' > temp.id	#capture only id value
sed -i '1,5d' temp.id  #remove first5line
cat maxrmsd.log | grep -o -P '(?<=RMSD=).*(?=Pairs)' > temp.max	#capture only rmsd value 
sed 's/(//' temp.max > maxi #remove "("
sed -i "s/ //g" maxi	#remove whitespace in file
paste temp.id maxi | column -s $'\t' -t > RMSD.csv
sed -i '/native/d' RMSD.csv
rm temp* #remove temp files

#3. Combine rmsd with scores from rosetta abinitio

sed '1d' *.fsc > temp_nhscore.fsc 	#remove 1st header line and make new file (does not disturb source file)
cat temp_nhscore.fsc | awk '{print $2, $NF}' > temp_scoreID.txt 	
cat temp_scoreID.txt | awk '{print $NF}' > temp_IDs.txt
cut -d '_' -f 2 temp_IDs.txt > temp_IDs1.txt
paste temp_scoreID.txt temp_IDs1.txt | column -s $'\t' -t > alignscore.txt	#merge back ID.txt with scoreID.txt
cat RMSD.csv | awk '{print $1}' > temp_IDt.txt 
cut -d '_' -f 2 temp_IDt.txt > temp_IDt1.txt
paste RMSD.csv temp_IDt1.txt | column -s $'\t' -t > aligntm.txt	#merge both files
cat alignscore.txt | sort -nk 3 > temp_aS.txt
cat aligntm.txt | sort -nk 3 > temp_aT.txt
paste temp_aS.txt temp_aT.txt | column -s $'\t' -t > scoretmalign.txt
cat scoretmalign.txt | awk '{print $4, $5, $1, $6}' > final.scoretmalign.csv
rm temp_*	#cleanup

#4. Generate evaluation plot: rmsd vs score

cat *.scoretmalign.csv | awk '{print $1, $2, $3}' > plot_data	#prepare the table
sed -i '1iID, rmsd, score' plot_data #add header
gnuplot -persist <<-EOFMarker
	set term png 	#will produce png output
	set output 'scatter.png'	#output filename
	set title 'score_vs_rmsd'
	set xlabel 'rmsd'
	set ylabel 'score'
	set timestamp
	plot 'plot_data' using 2:3 with points		#plot column 2 (rms_core) vs 3 (score)	
EOFMarker
mv plot_data final.plot_data
mv scatter.png final.scatter.png


#plots for values below 0

awk '{if ($3 < 0) print $1, $2, $3}' *.scoretmalign.csv > plot_data2	#filter for only values below 0
sed -i '1iID, rmsd, score' plot_data2 #add header
gnuplot -persist <<-EOFMarker
	set term png 	#will produce png output
	set output 'scatter2.png'	#output filename
	set title 'score_vs_rmsd'
	set xlabel 'rmsd'
	set ylabel 'score'
	set timestamp
	plot 'plot_data2' using 2:3 with points		#plot column 2 (rms_core) vs 3 (score)	
EOFMarker
mv plot_data2 final.plot_data2
mv scatter2.png final.scatter2.png

#5. Extract top 10 pdbs and save as pngs
#native.pdb will still be there
mkdir Top10pdbs

cat *.fsc | awk '{print $NF, $2}' | sort -nk 2 | head -10 > top10score
cat top10score | sed '/^$/d' | awk '{print $1".pdb"}' > top10list  #delete empty line and append with ending of .pdb
tar xjf *pdb.tar.bz2 -T top10list #untar pdb of nativelist from pdb.tar.bz2 file

for x in ./*.pdb
do
	echo "load $x;" > $x.pml	#creating pymol script
	echo "set ray_opaque_background, on;" >> $x.pml
	echo "show cartoon;" >> $x.pml
	echo "color purple, ss h;" >> $x.pml
	echo "color yellow, ss s;" >> $x.pml
	echo "ray 380,380;" >> $x.pml
	echo "png $x.png;" >> $x.pml
	echo "quit;" >> $x.pml
	pymol -qxci $x.pml
	rm -rf $x.pml $x.pdb
done

mv *.pdb *.pdb.png Top10pdbs

#VALIDATION STEPS
#validate models using PROCHECK, Verify3D, QMEAN and PROSA
