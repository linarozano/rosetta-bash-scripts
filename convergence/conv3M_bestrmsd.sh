#!/bin/bash
#Lrlrlr 300519 conv3M.sh
#script to manage output data and process outputs for convergence test
#will have in 3 continuous version from magnus to zeus.

#process for best rmsd
for d in ./*_cv
do
	cd "$d"
	cat *.scoretmalign.csv | awk '{print $4}' | tail -1 > temp_1	#1st column: take value of number from last line of ID for each
	cat *.scoretmalign.csv | sort -nk 2 | head -1 | awk '{print $3}' > temp_2	#2nd column: take value of best score for each
	cat *.scoretmalign.csv | sort -nk 2 | head -1 | awk '{print $2}' > temp_3	#3rd column: take value of best rmsd for each
	paste temp_1 temp_2 | column -s $'\t' -t > $d.temp_bs2
	paste temp_1 temp_3 | column -s $'\t' -t > $d.temp_br2
	cp *.temp_bs2 ../scoretmalign
	cp *.temp_br2 ../scoretmalign
	rm *temp*
	cd ..
done
cd scoretmalign
cat *.temp_bs2 | sort -nk 1 > independent_score2.csv	
cat *.temp_br2 | sort -nk 1 > independent_rmsd2.csv
rm *temp*
cd ..
#pass
#process csv file to capture required data
for d in ./50*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00040001/,$d' temp_sorted > temp_40k  
		cat temp_40k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line40
		sed '/00030001/,$d' temp_sorted > temp_30k  
		cat temp_30k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line30
		sed '/00020001/,$d' temp_sorted > temp_20k  
		cat temp_20k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line20
		sed '/00010001/,$d' temp_sorted > temp_10k  
		cat temp_10k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line10
		sed '/00007501/,$d' temp_sorted > temp_7p5k  
		cat temp_7p5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line7p5k
		sed '/00005001/,$d' temp_sorted > temp_5k  
		cat temp_5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line5
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_line5 temp_line7p5k temp_line10 temp_line20 temp_line30 temp_line40 temp_end > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore2	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd2	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID2	#capture only IDs of above scores and rmsd
		cp *.singlerunscore2 ../scoretmalign
		cp *.singlerunrmsd2 ../scoretmalign
		cp *.singlerunID2 ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done
	
for d in ./40*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00030001/,$d' temp_sorted > temp_30k  
		cat temp_30k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line30
		sed '/00020001/,$d' temp_sorted > temp_20k  
		cat temp_20k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line20
		sed '/00010001/,$d' temp_sorted > temp_10k  
		cat temp_10k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line10
		sed '/00007501/,$d' temp_sorted > temp_7p5k  
		cat temp_7p5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line7p5k
		sed '/00005001/,$d' temp_sorted > temp_5k  
		cat temp_5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line5
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_line5 temp_line7p5k temp_line10 temp_line20 temp_line30 temp_end temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore2	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd2	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID2	#capture only IDs of above scores and rmsd
		cp *.singlerunscore2 ../scoretmalign
		cp *.singlerunrmsd2 ../scoretmalign
		cp *.singlerunID2 ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./30*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00020001/,$d' temp_sorted > temp_20k  
		cat temp_20k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line20
		sed '/00010001/,$d' temp_sorted > temp_10k  
		cat temp_10k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line10
		sed '/00007501/,$d' temp_sorted > temp_7p5k  
		cat temp_7p5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line7p5k
		sed '/00005001/,$d' temp_sorted > temp_5k  
		cat temp_5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line5
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_line5 temp_line7p5k temp_line10 temp_line20 temp_end temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore2	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd2	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID2	#capture only IDs of above scores and rmsd
		cp *.singlerunscore2 ../scoretmalign
		cp *.singlerunrmsd2 ../scoretmalign
		cp *.singlerunID2 ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./20*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00010001/,$d' temp_sorted > temp_10k  
		cat temp_10k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line10
		sed '/00007501/,$d' temp_sorted > temp_7p5k  
		cat temp_7p5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line7p5k
		sed '/00005001/,$d' temp_sorted > temp_5k  
		cat temp_5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line5
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_line5 temp_line7p5k temp_line10 temp_end temp_empty temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore2	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd2	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID2	#capture only IDs of above scores and rmsd
		cp *.singlerunscore2 ../scoretmalign
		cp *.singlerunrmsd2 ../scoretmalign
		cp *.singlerunID2 ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./10*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00007501/,$d' temp_sorted > temp_7p5k  
		cat temp_7p5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line7p5k
		sed '/00005001/,$d' temp_sorted > temp_5k  
		cat temp_5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line5
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_line5 temp_line7p5k temp_end temp_empty temp_empty temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore2	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd2	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID2	#capture only IDs of above scores and rmsd
		cp *.singlerunscore2 ../scoretmalign
		cp *.singlerunrmsd2 ../scoretmalign
		cp *.singlerunID2 ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./7*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00005001/,$d' temp_sorted > temp_5k  
		cat temp_5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line5
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_line5 temp_end temp_empty temp_empty temp_empty temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore2	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd2	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID2	#capture only IDs of above scores and rmsd
		cp *.singlerunscore2 ../scoretmalign
		cp *.singlerunrmsd2 ../scoretmalign
		cp *.singlerunID2 ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./5k*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00002501/,$d' temp_sorted > temp_2p5k  
		cat temp_2p5k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line2p5k
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_line2p5k temp_end temp_empty temp_empty temp_empty temp_empty temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore2	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd2	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID2	#capture only IDs of above scores and rmsd
		cp *.singlerunscore2 ../scoretmalign
		cp *.singlerunrmsd2 ../scoretmalign
		cp *.singlerunID2 ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done

for d in ./2p5k*
do
	if [ -d ${d} ]	#only run if it is a directory
	then
		cd "$d"
		cat *.scoretmalign.csv | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_end
		cat *.scoretmalign.csv | head -1 | awk '{print $5}' > temp_empty
		cat *.scoretmalign.csv | sort -nk 4 >  temp_sorted
		sed '/00001001/,$d' temp_sorted > temp_1k  
		cat temp_1k | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_line1k
		cat temp_line1k temp_end temp_empty temp_empty temp_empty temp_empty temp_empty temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore2	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd2	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID2	#capture only IDs of above scores and rmsd
		cp *.singlerunscore2 ../scoretmalign
		cp *.singlerunrmsd2 ../scoretmalign
		cp *.singlerunID2 ../scoretmalign
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
		cat *.scoretmalign.csv | sort -nk 2 | head -1 | awk '{print $1, $2, $3}' > temp_sorted
		cat temp_sorted temp_empty temp_empty temp_empty temp_empty temp_empty temp_empty temp_empty temp_empty > temp_fullirs
		cat temp_fullirs | awk '{print $3}' > $d.singlerunscore2	#capture only scores
		cat temp_fullirs | awk '{print $2}' > $d.singlerunrmsd2	#capture only rmsd
		cat temp_fullirs | awk '{print $1}' > $d.singlerunID2	#capture only IDs of above scores and rmsd
		cp *.singlerunscore2 ../scoretmalign
		cp *.singlerunrmsd2 ../scoretmalign
		cp *.singlerunID2 ../scoretmalign
		rm temp* #cleanup
		cd ..
	fi
done


#create full table
mkdir convergence_plot2
cd scoretmalign
paste 50*.singlerunscore2 40*.singlerunscore2 30*.singlerunscore2 20*.singlerunscore2 10*.singlerunscore2 7*.singlerunscore2 5k*.singlerunscore2 2p*.singlerunscore2 1k*.singlerunscore2| column -s $'\t' -t > temp_srs 
paste independent_score2.csv temp_srs | column -s $'\t' -t > bestscore2.csv	#table of best scores of independent and single runs
paste 50*.singlerunrmsd2 40*.singlerunrmsd2 30*.singlerunrmsd2 20*.singlerunrmsd2 10*.singlerunrmsd2 7*.singlerunrmsd2 5k*.singlerunrmsd2 2p*.singlerunrmsd2 1k*.singlerunrmsd2 | column -s $'\t' -t > temp_srr
paste independent_rmsd2.csv temp_srr | column -s $'\t' -t > bestrmsd2.csv	#table of best rmsd of independent and single runs
paste 50*.singlerunID2 40*.singlerunID2 30*.singlerunID2 20*.singlerunID2 10*.singlerunID2 7*.singlerunID2 5k*.singlerunID2 2p*.singlerunID2 1k*.singlerunID2 | column -s $'\t' -t > temp_sri
paste independent_score2.csv temp_sri | column -s $'\t' -t > ID2.csv		#table of ID of best scores/rmsd of independent and single runs
rm *temp* *singlerun* #cleanup
#fix table
cp bestscore2.csv bestrmsd2.csv ID2.csv ../convergence_plot2
cd ..

#pass
#need sort in reverse func later using sort -r
#line plots for bestscore.csv, bestrmsd.csv and ID.csv
cd convergence_plot2
#for bestrmsd.csv

gnuplot -persist <<-EOFMarker
	set term png 	
	set output 'bestrmsd.png'	
	set title 'rmsd of the best rmsd'
	set xlabel 'score'
	set ylabel 'rmsd'
	set timestamp
	plot 'bestrmsd2.csv' using 1:2 with linespoints title 'Independent Runs', 'bestrmsd2.csv' using 1:3 with linespoints title '50,000', 'bestrmsd2.csv' using 1:4 with linespoints title '40,000', 'bestrmsd2.csv' using 1:5 with linespoints title '30,000', 'bestrmsd2.csv' using 1:6 with linespoints title '20,000', 'bestrmsd2.csv' using 1:7 with linespoints title '10,000', 'bestrmsd2.csv' using 1:8 with linespoints title '7,500', 'bestrmsd2.csv' using 1:9 with linespoints title '5,000', 'bestrmsd2.csv' using 1:10 with linespoints title '2,500', 'bestrmsd2.csv' using 1:11 with linespoints title '1,000'
EOFMarker


#for bestscore.csv
gnuplot -persist <<-EOFMarker
	set term png 	
	set output 'bestscore.png'	
	set title 'score_vs_rmsd'
	set xlabel 'score'
	set ylabel 'rmsd'
	set timestamp
	plot 'bestscore2.csv' using 1:2 with linespoints title 'Independent runs', 'bestscore2.csv' using 1:3 with linespoints title '50,000', 'bestscore2.csv' using 1:4 with linespoints title '40,000', 'bestscore2.csv' using 1:5 with linespoints title '30,000', 'bestscore2.csv' using 1:6 with linespoints title '20,000', 'bestscore2.csv' using 1:7 with linespoints title '10,000', 'bestscore2.csv' using 1:8 with linespoints title '7,500', 'bestscore2.csv' using 1:9 with linespoints title '5,000', 'bestscore2.csv' using 1:10 with linespoints title '2,500', 'bestscore2.csv' using 1:11 with linespoints title '1,000'
EOFMarker

cd ..
#extract pdb of allbestscore and allbestrmsd
mkdir bestrmsd_extractedpdb
for d in ./*_cv
do
	cd "$d"
	rm S_*.pdb 	#from previous best score (allS)
	cat *.singlerunID2 | sed '/^$/d' | awk '{print $0".pdb"}' > PDBtoextract2  #delete empty line and append with ending of .pdb
	tar xjf *pdb.tar.bz2 -T PDBtoextract2
	cp S_*.pdb F_*.pdb ../bestrmsd_extractedpdb
	cd ..
done

#final cleanup













