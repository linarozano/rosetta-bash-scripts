#!/bin/bash 
#Lrlrlr 040220 splitNcluster.sh (on Zeus)
#Script to  split *.plot_data2 scores into range of 10 and cluster them based on the range
#in hope of getting the biggest cluster to contain the best model after splitting based on range
#split the file into multiple files at every score differences of 10

#line to combine bash with python
#extract only below pdb from *k_cv.plot_data2 pdb from tar.bz2 file
tar xjf *.pdb.tar.bz2	#decompress

#compile with python script to split data into ranges of 10
import numpy as np
inputfile='50k_test'
binwidth=10
cage = np.loadtxt(inputfile, dtype=np.str, skiprows=1)
r=cage[:,0]
x=cage[:,1]
x=x.astype(np.float)
y=cage[:,2]
y=y.astype(np.float)
max=np.amax(y)
min=np.amin(y)
R=np.arange(min,(max+binwidth),binwidth)
#print(r)
#print(x)
#print(y)

for i in range(0, len(R)):
    see=np.where((y >=(min+(i*binwidth))) & (y <=(min+((i+1)*binwidth))))
    outputfile="inputfile"+str(i)
    #print(see)
    #print(cage[see])
    np.savetxt(outputfile, cage[see], delimiter=' ', fmt="%s")

#check which inputfile the most dense
#check which inputfile contain the best tmscore model


#prepare file #2 seq.dat
#obtain data from the first pdb file
cat *1.pdb | awk '{print $6"\t"$4}' > temp2a
sed -i '/weighted/,$d' temp2a #remove line starting from weighted
sed -i '$d' temp2a #delete empty line
awk '!seen[$0]++' temp2a > seq.dat #remove duplicates
rm temp* #cleanup
 
#prepare file #3 tra.in
#calculate no of decoys in inputfile for data in tra.in
wc -l inputfile6 > temp1a
cat temp1a | awk '{print $1}' > head2
#manually insert 2 other params (-1 1) --unless i can find a way to automate it
#list of pdb files to be clustered
cat inputfile1 | awk '{print $1".pdb.b"}' > temp1b
cat head2 temp1b > tra.in #CUSTOM based on no of pdbs
rm temp* #cleanup

#preparing file #4 rep1.tra1/pdb1b (ONLY ONCE)
#prepare pdb file coordinates-convert all to spicker format (capture only line #7-9)
for x in ./*pdb
do
	cat "$x" | awk '{print $7"\t"$8"\t"$9}' > $x.a
	sed -i '/score/,$d' $x.a #remove line starting from score
	sed -i '$d' $x.a #delete empty line
	cat head1a $x.a > $x.b
	rm *pdb.a #cleanup
done

#run clustering using SPICKER 
#required files: 1)rmsinp=region for rmsd calculation with protein length-MANUAL PREP
#2)seq.dat=sequence file (fasta file)
#3)tra.in=list of trajectory names used for clustering (output from phyton script above..inputfile*
#4)rep1.tra1 (pdb1b)= the decoy file containing param line(decoy length, score, 1, 1)+ coordinates
#same file for all: rmsinp, seq.dat


#OUTPUT file
#str.txt, combo*.pdb, closc*.pdb, rst.dat
mkdir input5
mv str.txt combo*.pdb closc*.pdb rst.dat input5

#running using native for tmscore calculation. native pdb file need to be processed before running
#remove line 5, 10, 11, 12 using 
sed -i -r 's/\S+//3' CA
#only retain CA line
grep -e CA CA > CA2
#renumber column 2 in file
awk '{$2=NR}{print}' file #will remove tab and make file not functional#need to fix

#Cluster using Legacy

