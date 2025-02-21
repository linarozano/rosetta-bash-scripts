#!/bin/bash
#Lrlrlr 141019 abs.sh updated 301019- non-native mode updated 130120 updated 130220 abs_candyV2.sh
#Post processing of abinitio runs, script to run rosetta abinitio on a candidate with no known native.pdb

#extract and backup from output results
score_jd2.default.linuxgccrelease --in:file:silent *.out --in:file:fullatom --out:pdb --out:file:fullatom --no_nstruct_label	
tar -cjf extracted.pdb.tar.bz2 F_* S_*
tar -cjf results.outs.tar.bz2 *.out
tar -cjf inputdata.tar.bz2 *err *log aat000* t000* *options *tpb
rm *.out