#!/bin/bash

### Set the location of some important directories ###
BW_ROSETTA_BIN=/projects/sciteam/gk4/rosetta_3.8_static/main/source/bin/
APP=fixbb.static.linuxgccrelease
PBS_O_WORKDIR=`pwd`

### Only want to repack the receptor, so split lig + rec into two separate pdbs ###
awk '$5 == "A"' N21-HLLY6-Drec_Llig-1lig.FOR_PEPSPEC.pdb > REC.pdb
awk '$5 == "B"' N21-HLLY6-Drec_Llig-1lig.FOR_PEPSPEC.pdb >> REC.pdb
awk '$5 == "C"' N21-HLLY6-Drec_Llig-1lig.FOR_PEPSPEC.pdb >> REC.pdb
awk '$5 == "G"' N21-HLLY6-Drec_Llig-1lig.FOR_PEPSPEC.pdb > LIG.pdb

sleep 10

### Run FIXBB to repack
$BW_ROSETTA_BIN/$APP -s ./REC.pdb -out:file:o fixbb.out -ex1 -ex2 -extrachi_cutoff 0 -overwrite -nstruct 1 -packing:repack_only

sleep 10

### Put evertything back together
awk '$5 == "A"' REC_0001.pdb > DRec_Llig.repacked.pdb
awk '$5 == "B"' REC_0001.pdb >> DRec_Llig.repacked.pdb
awk '$5 == "C"' REC_0001.pdb >> DRec_Llig.repacked.pdb
awk '$5 == "G"' LIG.pdb >> DRec_Llig.repacked.pdb

sleep 10

exit 0
