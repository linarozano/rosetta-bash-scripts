#!/bin/bash
#Lrlrlr 021219 highRESplot.sh
#script to generate high resolution plots using gnuplot in postscript or svg format.-for clustering plot
#input is *plot_cluster

gnuplot -persist <<-EOFMarker
	set term png 	#will produce png output
	set output '10k.cluster.png'	#output filename
	set title 'score_vs_rmsd'
	set xlabel 'rmsd'
	set ylabel 'score'
	plot '10k.plot_cluster' with points palette		#plot column 2 (rms_core) vs 3 (score)	
EOFMarker

gnuplot -persist <<-EOFMarker
	set term svg 	#will produce svg output
	set output '10k.cluster.svg'	#output filename
	set title 'score_vs_rmsd'
	set xlabel 'rmsd'
	set ylabel 'score'
	plot '10k.plot_cluster' with points palette		#plot column 2 (rms_core) vs 3 (score)	
EOFMarker


gnuplot -persist <<-EOFMarker
	set terminal postscript eps enhanced color font 'Helvetica,10'	#will produce postscript output
	set output '10k.cluster.eps'	#output filename
	set title 'score_vs_rmsd'
	set xlabel 'rmsd'
	set ylabel 'score'
	plot '10k.plot_cluster' with points palette		#plot column 2 (rms_core) vs 3 (score)	
EOFMarker