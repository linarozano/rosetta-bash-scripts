#!/bin/bash
# render-pymol.sh
if [ $# -eq 0 ]
  then
    echo "Usage: render-pymol.sh <PDB ID>"
    exit
fi
#Download
wget -qO $1.pdb http://www.rcsb.org/pdb/files/$1.pdb

#Create the rasmol script
echo "load $1.pdb;" > $1.pml
echo "set ray_opaque_background, on;" >> $1.pml
echo "show cartoon;" >> $1.pml
echo "color purple, ss h;" >> $1.pml
echo "color yellow, ss s;" >> $1.pml
echo "ray 1500,1500;" >> $1.pml
echo "png $1.png;" >> $1.pml
echo "quit;" >> $1.pml

#Execute PyMol
pymol -qxci $1.pml
#Remove temporary files
rm -rf $1.pml $1.pdb