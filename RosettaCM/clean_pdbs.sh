#!/bin/bash
for pdb in `cat list_of_pdbs.txt`; do
	~/rosetta_workshop/rosetta/tools/protein_tools/scripts/clean_pdb.py $pdb A
done
