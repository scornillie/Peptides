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

### Create the runscript for and run the FIXBB application of Rosetta ###
cat > FIXBB.sh << EOF
#PBS -S /bin/bash
#PBS -l walltime=4:00:00,nodes=1:ppn=32:xe
#PBS -q high
#PBS -N Repack-Drec_Llig
#PBS -M seancornillie@gmail.com
#PBS -m abe
#PBS -j oe
#PBS -A gk4

cd $PBS_O_WORKDIR

# Set up modules
source /opt/modules/default/init/bash
module unload PrgEnv-cray
module load PrgEnv-pgi
module load netcdf

# Run Rosetta
aprun -n 1 -N 1 $BW_ROSETTA_BIN/$APP -s ./N21-HLLY6-Drec_Llig-1lig.FOR_PEPSPEC.pdb -o fixbb.out -ex1 -ex2 -extrachi_cutoff 0 -overwrite -nstruct 1 -packing:repack_only

exit 0
EOF
qsub FIXBB.sh &

awk '$5 == "A"' REC_0001.pdb > DRec_Llig.repacked.pdb
awk '$5 == "B"' REC_0001.pdb >> DRec_Llig.repacked.pdb
awk '$5 == "C"' REC_0001.pdb >> DRec_Llig.repacked.pdb
awk '$5 == "G"' LIG.pdb >> DRec_Llig.repacked.pdb

exit 0
