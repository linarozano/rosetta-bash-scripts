#!/bin/bash
#Lrlrlr 200319 combineRun_clear.sh
#Usage: to run bash script in all sub directories clear up specific files
#Script: clear_up.sh
#Magnus version

#use renaming for silent.out, or make exception

echo ./* | xargs -n 1 cp *.sh	#Copy clear_out script into all directories #cannot use specific name, if not will replace this file content

for d in ./*; do (cd "$d" && bash clear_out.sh); done	#Execute clear_out script

echo "Clear_out DONE!!!"



