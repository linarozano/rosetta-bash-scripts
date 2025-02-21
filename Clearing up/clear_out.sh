#!/bin/bash
#Lrlrlr 200319
#Usage: to delete single .out files and retain only silent.out in all folders.

for X in *.out; do [ "$X" != "silent.out" ] && rm "$X"; done	#To remove all .out files except for silent.out