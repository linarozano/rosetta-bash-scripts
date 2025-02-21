#!/bin/bash
#Lrlrlr 300519 conv3M.sh
#script to manage output data and process outputs for convergence test
#will have in 3 continuous version from magnus to zeus.

#on MAGNUS
#combine tmalign data with scores in score.fsc
#need to use delimiters to sort pdbID in incremental order for correct merging between tmalign.csv and score.fsc
#hv to remove header in score.fsc and native line in tmalign.csv

mkdir scoretmalign	
for d in ./*_cv
do
	cd "$d"
	sed '1d' *.score.fsc > temp_nhscore.fsc 	#remove 1st header line and make new file (does not disturb source file)
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
	cat scoretmalign.txt | awk '{print $4, $5, $1, $6}' > $d.scoretmalign.csv
	cp *.scoretmalign.csv ../scoretmalign
	rm temp_*	#cleanup
	cd ..
done

#reverse content in column 3 and beyond
#pass
#evaluation plot of score vs rmsd in xy scatterplots
#add header to $d.scoretmalign.csv (ID, rmsd, score)
mkdir evaluation_plots
for d in ./*_cv
do
	cd "$d"
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
	mv plot_data $d.plot_data
	mv scatter.png $d.scatter.png
	cp *.plot_data ../evaluation_plots
	cp *.scatter.png ../evaluation_plots
	cd ..
done

#plots for values below 0
mkdir evaluation_plots
for d in ./*_cv
do
	cd "$d"
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
	mv plot_data2 $d.plot_data2
	mv scatter2.png $d.scatter2.png
	cp *.plot_data2 ../evaluation_plots
	cp *.scatter2.png ../evaluation_plots
	cd ..
done

#pass
#to create table for convergence plot for independent runs
mkdir convergence_plots
for d in ./*_cv
do
	cd "$d"
	cat *.scoretmalign.csv | awk '{print $4}' | tail -1 > temp_1	#1st column: take value of number from last line of ID for each
	cat *.scoretmalign.csv | sort -nk 3 | head -1 | awk '{print $3}' > temp_2	#2nd column: take value of best score for each
	cat *.scoretmalign.csv | sort -nk 3 | head -1 | awk '{print $2}' > temp_3	#3rd column: take value of best rmsd for each
	paste temp_1 temp_2 | column -s $'\t' -t > $d.temp_bs
	paste temp_1 temp_3 | column -s $'\t' -t > $d.temp_br
	cp *.temp_bs ../scoretmalign
	cp *.temp_br ../scoretmalign
	rm *temp*
	cd ..
done
cd scoretmalign
cat *.temp_bs | sort -nk 1 > independent_score.csv	
cat *.temp_br | sort -nk 1 > independent_rmsd.csv
rm *temp*
cd ..
#pass
#process csv file to capture required data
for d in ./50*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00040001/,$d' temp_sorted > temp_40k  
		cat temp_40k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line40
		sed '/00030001/,$d' temp_sorted > temp_30k  
		cat temp_30k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line30
		sed '/00020001/,$d' temp_sorted > temp_20k  
		cat temp_20k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line20
		sed '/00010001/,$d' temp_sorted > temp_10k  
		cat temp_10k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line10
		sed '/00007501/,$d' temp_sorted > temp_7p5k  
		cat temp_7p5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line7p5k
		sed '/00005001/,$d' temp_sorted > temp_5k  
		cat temp_5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line5
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_line5 temp_line7p5k temp_line10 temp_line20 temp_line30 temp_line40 temp_end > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID	#capture only IDs of above scores and rmsd
		cp *.singlerunscore ../scoretmalign
		cp *.singlerunrmsd ../scoretmalign
		cp *.singlerunID ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done
	
for d in ./40*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00030001/,$d' temp_sorted > temp_30k  
		cat temp_30k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line30
		sed '/00020001/,$d' temp_sorted > temp_20k  
		cat temp_20k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line20
		sed '/00010001/,$d' temp_sorted > temp_10k  
		cat temp_10k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line10
		sed '/00007501/,$d' temp_sorted > temp_7p5k  
		cat temp_7p5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line7p5k
		sed '/00005001/,$d' temp_sorted > temp_5k  
		cat temp_5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line5
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_line5 temp_line7p5k temp_line10 temp_line20 temp_line30 temp_end temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID	#capture only IDs of above scores and rmsd
		cp *.singlerunscore ../scoretmalign
		cp *.singlerunrmsd ../scoretmalign
		cp *.singlerunID ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./30*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00020001/,$d' temp_sorted > temp_20k  
		cat temp_20k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line20
		sed '/00010001/,$d' temp_sorted > temp_10k  
		cat temp_10k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line10
		sed '/00007501/,$d' temp_sorted > temp_7p5k  
		cat temp_7p5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line7p5k
		sed '/00005001/,$d' temp_sorted > temp_5k  
		cat temp_5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line5
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_line5 temp_line7p5k temp_line10 temp_line20 temp_end temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID	#capture only IDs of above scores and rmsd
		cp *.singlerunscore ../scoretmalign
		cp *.singlerunrmsd ../scoretmalign
		cp *.singlerunID ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./20*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00010001/,$d' temp_sorted > temp_10k  
		cat temp_10k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line10
		sed '/00007501/,$d' temp_sorted > temp_7p5k  
		cat temp_7p5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line7p5k
		sed '/00005001/,$d' temp_sorted > temp_5k  
		cat temp_5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line5
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_line5 temp_line7p5k temp_line10 temp_end temp_empty temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID	#capture only IDs of above scores and rmsd
		cp *.singlerunscore ../scoretmalign
		cp *.singlerunrmsd ../scoretmalign
		cp *.singlerunID ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./10*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00007501/,$d' temp_sorted > temp_7p5k  
		cat temp_7p5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line7p5k
		sed '/00005001/,$d' temp_sorted > temp_5k  
		cat temp_5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line5
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_line5 temp_line7p5k temp_end temp_empty temp_empty temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID	#capture only IDs of above scores and rmsd
		cp *.singlerunscore ../scoretmalign
		cp *.singlerunrmsd ../scoretmalign
		cp *.singlerunID ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./7*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00005001/,$d' temp_sorted > temp_5k  
		cat temp_5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line5
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_line5 temp_end temp_empty temp_empty temp_empty temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID	#capture only IDs of above scores and rmsd
		cp *.singlerunscore ../scoretmalign
		cp *.singlerunrmsd ../scoretmalign
		cp *.singlerunID ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./5k*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_end temp_empty temp_empty temp_empty temp_empty temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID	#capture only IDs of above scores and rmsd
		cp *.singlerunscore ../scoretmalign
		cp *.singlerunrmsd ../scoretmalign
		cp *.singlerunID ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./2p5k*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_end temp_empty temp_empty temp_empty temp_empty temp_empty temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID	#capture only IDs of above scores and rmsd
		cp *.singlerunscore ../scoretmalign
		cp *.singlerunrmsd ../scoretmalign
		cp *.singlerunID ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./1k*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 3 | head -1 | awk '{print $1, $2, $3}' > temp_sorted
		cat temp_sorted temp_empty temp_empty temp_empty temp_empty temp_empty temp_empty temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID	#capture only IDs of above scores and rmsd
		cp *.singlerunscore ../scoretmalign
		cp *.singlerunrmsd ../scoretmalign
		cp *.singlerunID ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done


#create full table
cd scoretmalign
paste 50*.singlerunscore 40*.singlerunscore 30*.singlerunscore 20*.singlerunscore 10*.singlerunscore 7*.singlerunscore 5k*.singlerunscore 2p*.singlerunscore 1k*.singlerunscore| column -s $'\t' -t > temp_srs 
paste independent_score.csv temp_srs | column -s $'\t' -t > bestscore.csv	#table of best scores of independent and single runs
paste 50*.singlerunrmsd 40*.singlerunrmsd 30*.singlerunrmsd 20*.singlerunrmsd 10*.singlerunrmsd 7*.singlerunrmsd 5k*.singlerunrmsd 2p*.singlerunrmsd 1k*.singlerunrmsd | column -s $'\t' -t > temp_srr
paste independent_rmsd.csv temp_srr | column -s $'\t' -t > bestrmsd.csv	#table of best rmsd of independent and single runs
paste 50*.singlerunID 40*.singlerunID 30*.singlerunID 20*.singlerunID 10*.singlerunID 7*.singlerunID 5k*.singlerunID 2p*.singlerunID 1k*.singlerunID | column -s $'\t' -t > temp_sri
paste independent_score.csv temp_sri | column -s $'\t' -t > ID.csv		#table of ID of best scores/rmsd of independent and single runs
rm *temp* *singlerun* #cleanup
#fix table
cp bestscore.csv bestrmsd.csv ID.csv ../convergence_plots
cd ..

#pass
#need sort in reverse func later using sort -r
#line plots for bestscore.csv, bestrmsd.csv and ID.csv
cd convergence_plots
#for bestrmsd.csv

gnuplot -persist <<-EOFMarker
	set term png 	
	set output 'bestrmsd.png'	
	set title 'rmsd of the best score'
	set xlabel 'score'
	set ylabel 'rmsd'
	set timestamp
	plot 'bestrmsd.csv' using 1:2 with linespoints title 'Independent Runs', 'bestrmsd.csv' using 1:3 with linespoints title '50,000', 'bestrmsd.csv' using 1:4 with linespoints title '40,000', 'bestrmsd.csv' using 1:5 with linespoints title '30,000', 'bestrmsd.csv' using 1:6 with linespoints title '20,000', 'bestrmsd.csv' using 1:7 with linespoints title '10,000', 'bestrmsd.csv' using 1:8 with linespoints title '7,500', 'bestrmsd.csv' using 1:9 with linespoints title '5,000', 'bestrmsd.csv' using 1:10 with linespoints title '2,500', 'bestrmsd.csv' using 1:11 with linespoints title '1,000'
EOFMarker


#for bestscore.csv
gnuplot -persist <<-EOFMarker
	set term png 	
	set output 'bestscore.png'	
	set title 'score_vs_rmsd'
	set xlabel 'score'
	set ylabel 'rmsd'
	set timestamp
	plot 'bestscore.csv' using 1:2 with linespoints title 'Independent runs', 'bestscore.csv' using 1:3 with linespoints title '50,000', 'bestscore.csv' using 1:4 with linespoints title '40,000', 'bestscore.csv' using 1:5 with linespoints title '30,000', 'bestscore.csv' using 1:6 with linespoints title '20,000', 'bestscore.csv' using 1:7 with linespoints title '10,000', 'bestscore.csv' using 1:8 with linespoints title '7,500', 'bestscore.csv' using 1:9 with linespoints title '5,000', 'bestscore.csv' using 1:10 with linespoints title '2,500', 'bestscore.csv' using 1:11 with linespoints title '1,000'
EOFMarker

cd ..
#extract pdb of allbestscore and allbestrmsd
mkdir bestscore_extractedpdb
for d in ./*_cv
do
	cd "$d"
	cat *.singlerunID | sed '/^$/d' | awk '{print $0".pdb"}' > PDBtoextract  #delete empty line and append with ending of .pdb
	tar xjf *pdb.tar.bz2 -T PDBtoextract
	cp S_*.pdb ../bestscore_extractedpdb
	cd ..
done

#final cleanup













