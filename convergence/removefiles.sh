#!/bin/bash
#script to remove all files except the ones for convergence4 and the scripts
for d in ./*_cv
do
	cd "$d"
	shopt -s extglob
	rm -v !(*.pdb.tar.bz2|tmalign.*|native.*|*.score.fsc|conv4*)
	shopt -u extglob
	cd ..
done

GLOBIGNORE=*.pdb.tar.bz2:tmalign.*:native.*:*.score.fsc:conv4*
rm -v *
unset GLOBIGNORE