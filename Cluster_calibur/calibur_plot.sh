#!/bin/bash
#Lrlrlr 300319 calibur_plot.sh
#To read output of calibur results and make some sense out of it

#Process the output file .calibur
#Take everything beyond "Finding and removing largest clusters line"

#Define largest 2 clusters for each directory
#take the whole line create new column before this to add $modelname, save in one txt file called cluster_summary.txt

#Create list of all file name in one txt file
ls > filelist
# only call lines with calibur and remove.calibur can also #remove line in listje if include in filelist sed '/filelist/d' file. 
cat filelist | grep -o -P '(?<=).*(?=.calibur)' > list1

#Grab only line containing Largest 2 cluster.... until margin %
for x in ./*.calibur; do (cat $x |grep "Margin =" > $x.summary ); done

#combine summary.txt
cat *.summary > list2
sed -i "s/ //g" list1 	#remove whitespace in file
sed -i "s/ //g" list2
paste list1 list2 | column -s $'\t' -t > summary_calibur.csv

#Remove temp files
rm *summary filelist list1 list2
echo " summary_calibur.csv completed!"

#Master execution line
#for d in ./*; do (cd "$d" && bash calibur_plot.sh); done
#Completed in 3 seconds for 98 .calibur files

#error in file generated from clustering, so need some rules
#list2 must have only 1 line, if have 2/>lines of the same sentence, take the last one
#list2 if mix with running sentence, have to filter out compulsary words and paste in new file

#Troubleshoot&checking
tail -n +1 file1.txt file2.txt file3.txt 	#display contents of files with filename
wc -l .txt 	#read number of lines
tail -n 1 *summary   #only take the last line in a text file #in the case of multiple line results
sed -n '$p' > fmf.txt
for x in ./*.calibur; do (cat $x |sed -n '$p' > $x.summary2 ); done
 
#for d in ./*; do (cd "$d" && cat $d.csv | sort -nk 2 | head -11 > top10.txt ); done
#for x in ./*.pdb; do (mkdir "${x%.*}" && cp "$x" "${x%.*}" && cp template.pdb "${x%.*}"); done
#cat *.calibur |awk '/L*%/{print}'| tail -1 > summary
#cat *.calibur | grep -o -P '(?<=./).*(?=.pdb)' > id.log	
#sed -i "s/ //g" id.log 	#remove whitespace in file
#cat tmalign.log | grep -o -P '(?<=RMSD=).*(?=,)' > rmsd.log		#capture only rmsd value 
#sed -i "s/ //g" rmsd.log 	#remove whitespace in file



