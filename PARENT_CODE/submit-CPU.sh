#PBS -S /bin/bash
#PBS -l walltime=00:10:00,nodes=1:ppn=32:xe
#PBS -q debug
#PBS -N run-ZZZZ
#PBS -M seancornillie@gmail.com
#PBS -m abe
#PBS -j oe
#PBS -A gk4

. /opt/modules/default/init/bash
module unload PrgEnv-cray
module load PrgEnv-pgi
module load netcdf

source /projects/sciteam/gk4/amber-pgi/amber.sh

export AMBERHOME="/projects/sciteam/gk4/amber-pgi"
export SANDEREXE="$AMBERHOME/bin/pmemd.MPI"
export SCRIPTS="/u/sciteam/sean/scratch/EBOLA_2017/scripts-sean"
export LIB="/u/sciteam/sean/scratch/EBOLA_2017/lib-sean"

export PMI_NO_FORK=1
export PMI_NO_PREINITIALIZE=1

cd $PBS_O_WORKDIR

SERIE=ZZZZ

########################################
##          Build Systems             ##
########################################
for sim in 1;
do
  mkdir $sim
  cd $sim
  
  rm -rf 2build
  mkdir 2build
  cd 2build

  cp /scratch/sciteam/sean/EBOLA_2017/block-AAA/1PEPSPEC/$SERIE/data.$SERIE.pdbs/data.${SERIE}_${sim}.pdb ./
  cp ./data.${SERIE}_${sim}.pdb ./peptide.pdb
  awk '$1 == "data.'"$SERIE"'.pdbs/data.'"$SERIE"'_'"$sim"'.pdb" {print $0}' /scratch/sciteam/sean/EBOLA_2017/block-AAA/1PEPSPEC/$SERIE/data.$SERIE.spec > ./data.spec
  aprun -n 32 $SCRIPTS/build-CPU.sh > log &

  cd ../../
  sleep 2
done
wait

########################################
##             Min/Equil              ##
########################################

## Just in case.. ##
source /projects/sciteam/gk4/amber-pgi/amber.sh

for sim in 1;
do
  cd $sim

  rm -rf 3equil
  mkdir 3equil
  cd 3equil

  aprun -n 32 $SCRIPTS/equil-CPU.sh > log &

  cd ../../
  sleep 2
done
wait

########################################
##        Production MD               ##
########################################  
for sim in 1;
do
  cd $sim

  rm -rf 4MD
  mkdir 4MD
  cd 4MD

  aprun -n 32 $SANDEREXE -O -i $SCRIPTS/ebola.mdin -o out -p ../peptide.tip3p.200mM.hmass.prmtop -c ../peptide.tip3p.rand.rst.000 -x traj.nc -inf mdinfo &

  cd ../../
  sleep 2
done
wait

sleep 20
exit 0

