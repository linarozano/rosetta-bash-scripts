#!/bin/bash
#Lrlrlr 250719 edit render-pymol.sh

for x in ./*.pdb
do
	echo "load $x;" > $x.pml
	echo "set ray_opaque_background, on;" >> $x.pml
	echo "show cartoon;" >> $x.pml
	echo "color purple, ss h;" >> $x.pml
	echo "color yellow, ss s;" >> $x.pml
	echo "ray 380,380;" >> $x.pml
	echo "png $x.png;" >> $x.pml
	echo "quit;" >> $x.pml
	pymol -qxci $x.pml
	rm -rf $x.pml $x.pdb
done
