#PBS -S /bin/bash
#PBS -l walltime=24:00:00,nodes=100:ppn=1:xe
#PBS -q high
#PBS -N analyze-ZZZZ
#PBS -M seancornillie@gmail.com
#PBS -m abe
#PBS -j oe
#PBS -A gk4

. /opt/modules/default/init/bash
module unload PrgEnv-cray
module load PrgEnv-gnu
module load netcdf

source /projects/sciteam/gk4/amber-pgi/amber.sh

export AMBERHOME="/projects/sciteam/gk4/amber-pgi"
export SCRIPTS="/u/sciteam/sean/scratch/EBOLA_2017/scripts-sean"
export LIB="/u/sciteam/sean/scratch/EBOLA_2017/lib-sean"

export PMI_NO_FORK=1
export PMI_NO_PREINITIALIZE=1

cd $PBS_O_WORKDIR

SERIE=ZZZZ

########################################
##        Stript to in vacuo          ##
##        CPPTRAJ Analyses            ##
########################################
for sim in {1..100};
do
  cd $sim
  mkdir 5ANALYZE
  cd 5ANALYZE

  aprun -n 1 $SCRIPTS/analyze-cpptraj-CPU.sh > log-cpptraj &

  cd ../../
  sleep 2
done
wait

########################################
##         Run GB/PB SA               ##
########################################

source /u/sciteam/sean/amber14/amber.sh

for sim in {1..100};
do
  cd $sim
  mkdir 5ANALYZE
  cd 5ANALYZE

  aprun -n 1 $SCRIPTS/run_mmpbsa-CPU.sh > log-mmpbsa &

  cd ../../
  sleep 2
done
wait

sleep 20
exit 0
