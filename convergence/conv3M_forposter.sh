#!/bin/bash
#Lrlrlr 300519 conv3M.sh 
#script to manage output data and process outputs for convergence test
#the 3rd script

#on MAGNUS
#combine tmalign data with scores in score.fsc
#need to use delimiters to sort pdbID in incremental order for correct merging between tmalign.csv and score.fsc
#hv to remove header in score.fsc and native line in tmalign.csv

sed '1d' score.fsc > temp_nhscore.fsc 	#remove 1st header line and make new file (does not disturb source file)
cat temp_nhscore.fsc | awk '{print $2, $NF}' > temp_scoreID.txt 	
cat temp_scoreID.txt | awk '{print $NF}' > temp_IDs.txt
cut -d '_' -f 2 temp_IDs.txt > temp_IDs1.txt
paste temp_scoreID.txt temp_IDs1.txt | column -s $'\t' -t > alignscore.txt	#merge back ID.txt with scoreID.txt
sed -i '/native/d' tmalign.csv	#process tmalign.csv (ID, rmsd) -no header but need to remove native line (will change source file)
cat tmalign.csv | awk '{print $1}' > temp_IDt.txt 
cut -d '_' -f 2 temp_IDt.txt > temp_IDt1.txt
paste tmalign.csv temp_IDt1.txt | column -s $'\t' -t > aligntm.txt	#merge both files
cat alignscore.txt | sort -nk 3 > temp_aS.txt
cat aligntm.txt | sort -nk 3 > temp_aT.txt
paste temp_aS.txt temp_aT.txt | column -s $'\t' -t > scoretmalign.txt
cat scoretmalign.txt | awk '{print $4, $5, $1, $6}' > 10k.scoretmalign.csv
rm temp_*	#cleanup

#reverse content in column 3 and beyond
#pass
#evaluation plot of score vs rmsd in xy scatterplots
#add header to $d.scoretmalign.csv (ID, rmsd, score)

cat *.scoretmalign.csv | awk '{print $1, $2, $3}' > plot_data	#prepare the table
sed -i '1iID, rmsd, score' plot_data #add header
gnuplot -persist <<-EOFMarker
	set term png 	#will produce png output
	set output 'scatter.png'	#output filename
	set title 'score_vs_rmsd'
	set xlabel 'rmsd'
	set ylabel 'score'
	set timestamp
	plot 'plot_data' using 2:3 with points		#plot column 2 (rmsd) vs 3 (score)	
EOFMarker
mv plot_data 10k.plot_data
mv scatter.png 10k.scatter.png


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
	plot 'plot_data2' using 2:3 with points		#plot column 2 (rmsd) vs 3 (score)	
EOFMarker
mv plot_data2 10k.plot_data2
mv scatter2.png 10k.scatter2.png





























