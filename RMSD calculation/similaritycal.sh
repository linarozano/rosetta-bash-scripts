#!/bin/bash
#Lrlrlr 040819 similaritycal.sh
#Calculate structure similarity using MaxCluster tool (installed on Magnus)
#TM-score, RMSD, MaxSub, GDT-TS, GDT-HA
#Compare decoys vs template PDBs

#maxcluster directory
./group/pawsey0110/lrozano/maxcluster/maxcluster64bit -h

#untar compressed pdbs
tar xjf masterpdb.tar.bz2

#run calculation
./group/pawsey0110/lrozano/maxcluster/maxcluster64bit native.pdb cluster*.pdb

#location of the decoys
/scratch/pawsey0110/lrozano/newRMSDs/cluster6c.99.0.pdb

#THIS WORKS:
#maxsub calculation
./maxcluster64bit native.pdb /scratch/pawsey0110/lrozano/newRMSDs/cluster6c.99.0.pdb

Pairs	=	Number of pairs in the MaxSub
RMSD	=	RMSD of the MaxSub atoms
MAXSUB	=	MaxSub score
Len	=	Number of matched pairs
gRMSD	=	Global RMSD using the MaxSub superposition
TM	=	TM-score

#normal rmsd calculation
./maxcluster64bit native.pdb /scratch/pawsey0110/lrozano/newRMSDs/cluster6c.99.0.pdb -rmsd

RMSD	=	RMSD of superposition
Pairs	=	Number of matched pairs
rRMSD	=	Relative RMSD (z-score in brackets)
URMSD	=	URMSD of superposition
rURMSD	=	Relative URMSD (z-score in brackets)

#GDT calculation, the higher the better
./maxcluster64bit native.pdb /scratch/pawsey0110/lrozano/newRMSDs/cluster6c.99.0.pdb -gdt 
./maxcluster64bit native.pdb /scratch/pawsey0110/lrozano/newRMSDs/cluster6c.99.0.pdb -gdt 2 #for GDT-HA

#using pdbremix
pdbrmsd native.pdb cluster*.pdb