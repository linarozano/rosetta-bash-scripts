#!/bin/bash
#Lrlrlr 050819 evaluation_plot_withnewrmsd.sh edited 270919 for RL_case
#Input: *.pdb.tar.bz2 and score.fasc

#run newrmsd calculation
tar xjf extractedpdb.tar.bz2
for x in ./S_*.pdb
do
	pdbrmsd S_00014064.pdb "$x" > $x.rmsd
done
for x in ./F_*.pdb
do
	pdbrmsd S_00014064.pdb "$x" > $x.rmsd
done

#process output into table
cat *.rmsd > combinermsd	#this will be according to the listofpdb

cat combinermsd | grep -o -P '(?<=./).*(?=.0.pdb)' > clustername	 
sed -i "s/ //g" clustername 	#remove whitespace in file
cut -d '_' -f 2 clustername > indicator

cat combinermsd | grep -o -P '(?<=RMSD:).*(?=)' > capturermsd	#capture only rmsd value 
sed -i "s/ //g" capturermsd 	#remove whitespace in file

#paste clustername capturermsd indicator | column -s $'\t' -t > tablermsd
#rm cluster*.pdb cluster*.rmsd clustername indicator capturermsd

#Use capturermsd into table for plotting
cat capturermsd | grep -e RMSD	> temp.rmsdval #capture only line with RMSD: (has been arranged according to S_number)
cat capturermsd | grep -e ./S > temp.Sval	#capture only S_numbers

cat temp.rmsdval | grep -o -P '(?<=RMSD:).*(?=)' > rmsd.log		#capture only rmsd value 
sed -i "s/ //g" rmsd.log 	#remove whitespace in file
cat temp.Sval | grep -o -P '(?<=./).*(?=: all)' > id.log		#capture only id value 
sed -i "s/ //g" id.log 	#remove whitespace in file

#merge with scores from score.fasc
cat *fasc | awk '{print $NF"\t" $2}' > score.log
sed -i '1,2d' score.log #delete the first 2 lines containing definition

#prepare table for plotting
paste id.log rmsd.log score.log | column -s $'\t' -t > newrmsd.table
cat newrmsd.table | awk '{print $3"\t" $2"\t" $4}' > newrmsd.plot

#cleanup (edit this)

gnuplot -persist <<-EOFMarker
	set term png 	#will produce png output
	set output 'newrmsd.png'	#output filename
	set title 'evaluationplot_vs_rmsd'
	set xlabel 'rmsd'
	set ylabel 'score'
	set timestamp
	plot 'newrmsd.plot' using 2:3 with points		#plot column 2 (rmsd) vs 3 (score)	
EOFMarker

