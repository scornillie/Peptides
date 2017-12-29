#!/bin/bash

ROSETTA=/projects/sciteam/gk4/rosetta_3.8_static
PDB=

$ROSETTA/main/source/bin/rosetta_scripts.static.linuxgccrelease -parser:protocol flip_script.xml -in:file:s $PDB -in:file:fullatom
