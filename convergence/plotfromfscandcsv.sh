#!/bin/bash
#Lrlrlr 090619 adapted from evaluateCM2.sh
#plot score vs rmsd
#on MAGNUS
#generate table for plots and scatter plot.
#for 2mm0_disulfide

mkdir evaluation_plots
for d in ./*;
do
	cd "$d"
	sed '1d;2d' score.fasc > temp_nhscore.fsc 	#remove 1st and 2nd header line and make new file (does not disturb source file)
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
	cat scoretmalign.txt | awk '{print $4, $5, $1, $6}' > scoretmalign.csv
	rm temp_*	#cleanup
	cat scoretmalign.csv | awk '{print $1, $2, $3}' > plot_data	#prepare the table
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
	mv plot_data $d.plotdata
	mv scatter.png $d.plot.png
	cp *.plot.png *.plotdata ../evaluation_plots
	cd ..
done





 






