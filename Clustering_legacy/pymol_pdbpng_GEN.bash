#!/bin/bash
#Lrlrlr 250719 pymol_pdbpng.sh edited 140919- GENERALIZED

tar xjf *.tar.bz2
for x in ./*.pdb
do
	echo "load $x;" > $x.pml	#creating pymol script
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
rm *.pdb #cleanup
#tar -cjf extracted.PNG.tar.bz2 *.png
#rm *.png
mkdir pymol_images_all
mv .png pymol_images_all

