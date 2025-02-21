#!/bin/bash
#Lrlrlr 080319 combineRun_magnus
#Usage: to run bash script in all sub directories and save all output in new folder Plot_data
#Script: rmsdVSscore_magnus.sh and score_scatter_plot.py 
#Magnus version _max folders

mkdir Plot_data		#Create new folder to store output models.table and pdf plots
echo ./* | xargs -n 1 cp *sh	#Copy rmsdVSscore_plot.sh and score_scatter_plot.py scripts into all directories

for d in ./*; do (cd "$d" && bash rmsdVSscore_magnus.sh); done	#Execute the main script

# Rename output based on direcotry name
for d in ./*; do mv $d/models.table $d.table; done;		

mv *table Plot_data/	#Move all to new folder Plot_data




