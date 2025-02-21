#!/bin/bash
#Lrlrlr 020519 cleanV2.sh modified 110320
#clean after extracting pdbs

#compress and delete
tar -cjf SF_pdb.tar.bz2 F_*.pdb S_*.pdb
rm F_*.pdb S_*.pdb

echo "Folder cleaned!"

#Cleanup PDBs in folders and subfolders, before backing up on RDrive
for x in ./*mufold
do
	cd "$x"
	rm *.pdb
	cd ..
done

#Delete specific file in all directories and subdirectories
find . -name \*.pdb -type f -delete

