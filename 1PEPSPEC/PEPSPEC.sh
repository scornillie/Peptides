#PBS -S /bin/bash
#PBS -l walltime=24:00:00,nodes=11:ppn=32:xe
#PBS -q high
#PBS -N PEPSPEC-GGG
#PBS -M seancornillie@gmail.com
#PBS -m abe
#PBS -j oe
#PBS -A gk4

cd $PBS_O_WORKDIR

############################################################
##     Machine specific configurations                    ##
############################################################
. /opt/modules/default/init/bash
module unload PrgEnv-cray
module load PrgEnv-intel
module load netcdf

############################################################
##     Paths for libraries, programs and scripts          ##
############################################################
export ROSETTA="/projects/sciteam/gk4/rosetta_3.8_static/main"
export ROSETTA_DB="/projects/sciteam/gk4/rosetta_3.8_static/main/database"
export PEPSPEC="source/bin/pepspec.static.linuxgccrelease"
export REPACK="/scratch/sciteam/sean/EBOLA_2017/0REPACK"
#export SCRIPTS="/u/sciteam/ros/scratch/ebola/scripts"
#export LIB="/u/sciteam/ros/scratch/ebola/lib"
#export DB="/u/sciteam/ros/scratch/ebola/database/peptides2017may.db"

############################################################
##       Create pepspec argument file                     ##
############################################################
#cat > pepspec.args << EOF
#-pepspec:pep_anchor 4
#-pepspec:pep_chain G
#-pepspec:n_peptides 100
#-pepspec:binding_score true
#EOF
#
#wait
############################################################
##              Create unique directories                 ##
##        exp matches block# & anchor res (a,AAA,1)       ##
##  sim {a..j} creates 10*100 peptides per anchor res     ##
############################################################
for exp in g;
do
for sim in {a..k};
do
DIRECTORY=$exp$sim
mkdir $DIRECTORY
cd $DIRECTORY

############################################################
##           Set anchor (Res 4 - 14) for each dir         ##
############################################################
if [[ $DIRECTORY = "ga" ]]; then
ANCHOR="4"
fi

if [[ $DIRECTORY = "gb" ]]; then
ANCHOR="5"
fi

if [[ $DIRECTORY = "gc" ]]; then
ANCHOR="6"
fi

if [[ $DIRECTORY = "gd" ]]; then
ANCHOR="7"
fi

if [[ $DIRECTORY = "ge" ]]; then
ANCHOR="8"
fi

if [[ $DIRECTORY = "gf" ]]; then
ANCHOR="9"
fi

if [[ $DIRECTORY = "gg" ]]; then
ANCHOR="10"
fi

if [[ $DIRECTORY = "gh" ]]; then
ANCHOR="11"
fi

if [[ $DIRECTORY = "gi" ]]; then
ANCHOR="12"
fi

if [[ $DIRECTORY = "gj" ]]; then
ANCHOR="13"
fi

if [[ $DIRECTORY = "gk" ]]; then
ANCHOR="14"
fi

############################################################
##               Run Rosetta/Pepspec                      ##
############################################################
RSEED=`python -c 'import random; print random.randint(-2**31,2**31)';`
echo "$RSEED" >> RSEED.log
echo "$ANCHOR" >> ANCHOR.log
aprun -n 32 $ROSETTA/$PEPSPEC -database $ROSETTA_DB -run:constant_seed -run:jran $RSEED -in:file:s $REPACK/DRec_Llig.repacked.pdb -o data.$exp$sim -pepspec:pep_anchor $ANCHOR -pepspec:pep_chain G -pepspec:n_peptides 100 -pepspec:binding_score true -ex1 -ex2 -extrachi_cutoff 0 &
cd ../
done
done
wait
sleep 30

exit 0
