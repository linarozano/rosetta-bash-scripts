#!/bin/bash
#Lrlrlr 040819 rmsdcal.sh
#calculate rmsd using pdbremix:pdbrmsd function and plot for clusterdensity_vs_rmsd

#extract pdb from compressed file
#DO NOT FORGET TO COPY NATIVE.PDB INTO WORKING FOLDER 
#in the case of pure abinitio with no native, use the best score as native.

tar xjf masterpdb.tar.bz2
for x in ./*.0.pdb
do
	pdbrmsd native.pdb "$x" > $x.rmsd
done

#process output into table
cat *.rmsd > combinermsd	#this will be according to the listofpdb

cat combinermsd | grep -o -P '(?<=./).*(?=.0.pdb)' > clustername	 
sed -i "s/ //g" clustername 	#remove whitespace in file
cut -d '.' -f 2 clustername > indicator

cat combinermsd | grep -o -P '(?<=RMSD:).*(?=)' > capturermsd	#capture only rmsd value 
sed -i "s/ //g" capturermsd 	#remove whitespace in file

paste clustername capturermsd indicator | column -s $'\t' -t > tablermsd
rm cluster*.pdb cluster*.rmsd clustername indicator capturermsd

#merge with centroid table
cat tablermsd | sort -nk 3 > temp1

mv temp1 ../
cd ..
cat Cluster*.centroids | sort -nk 8 | awk '{print $1, $2, $3, $4, $5, $8, $9}' > temp2
paste temp1 temp2 | column -s $'\t' -t > newrmsd
#rm temp1 temp2

#Data for plotting of cluster density 
cat newrmsd | sort -nk 5 | awk '{print $1, $6, $2, $5, $8}'> dataplot
cat dataplot | awk '{print $2"\t"$3"\t"$4}' > plot_newrmsd


gnuplot -persist <<-EOFMarker
	set term png 	#will produce png output
	set output 'cluster_newrmsd.png'	#output filename
	set title 'clusterdensity_vs_rmsd'
	set xlabel 'cluster density'
	set ylabel 'rmsd'
	set timestamp
	plot 'plot_newrmsd' using 3:2 with points		#plot column 2 (rms_core) vs 3 (score)	
EOFMarker

