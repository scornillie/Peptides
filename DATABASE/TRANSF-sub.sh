#PBS -S /bin/bash
#PBS -l walltime=06:00:00,nodes=1:ppn=1:xe
#PBS -q high
#PBS -N transfer-GGG
#PBS -M seancornillie@gmail.com
#PBS -m abe
#PBS -j oe
#PBS -A gk4

cd $PBS_O_WORKDIR

aprun -n 1 ./transf.sh

wait
exit 0
