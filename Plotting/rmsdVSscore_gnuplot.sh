#!bin/bash
#Lrlrlr080319u250419 scoreVSrmsd_gnuplot.sh
#Purpose: to generate score vs rmsd_to_native table for plotting  excel

#Combine all silent output files and output as one silent.out file #only if i use python to plot
#combine_silent.default.linuxgccrelease -in:file:silent *.out -in:file:silent_struct_type binary -out:file:silent_struct_type binary -out:file:silent silent.out

#python score_scatter_plot.py --x_axis=rms_core --y_axis=score --silent=silent.out models.table	#Generate table containing models ID, rms_core and score and output models.table
#use cat instead
cat *fsc | awk '{print $NF"\t"$27"\t" $2}' > plot_data


#using gnuplot save in seperate file as scatter.gnuplot
#default terminal type is qt 0 font "Sans,9"
#this command is within gnuplot

gnuplot -persist <<-EOFMarker
	set title 'score_vs_rmscore'
	set xlabel 'rmscore'
	set ylabel 'score'
	set timestamp
	plot 'plot_data' using 2:3 with points		#plot column 2 (rms_core) vs 3 (score)
	set term png 	#will produce png output
	set output 'scatter.png'	#output filename
	replot 		#recreates plot but didnt see
	set term qt		#reset terminal view
EOFMarker



