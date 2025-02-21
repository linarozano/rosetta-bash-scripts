#!/bin/bash
#Lrlrlr 050919 extractpdb_andcompress.sh

score_jd2.default.linuxgccrelease --in:file:silent *.out --in:file:fullatom --out:pdb --out:file:fullatom --no_nstruct_label	#extract pdbs
tar -cjf extractedpdb.tar.bz2 F_* S_*
rm F_* S_*

#compress out files
tar -cjvf results_out.tar.bz2 *.out
rm *.out

