#!/bin/bash

AMBERHOME="/projects/sciteam/gk4/amber-pgi"

for exp in g;
do

for sim in {a..k};
do
DIRECTORY=$exp$sim
cd $DIRECTORY

for SIMID in */;
#for SIMID in $(ls -d */);
do
SIMID=${SIMID%?}
cd $SIMID

cd 5ANALYZE
$AMBERHOME/bin/cpptraj <<EOF
parm vacuo.topo
trajin vacuo.nc 2000 3000 1

strip !:1-96@N,CA,C,O
rms fit !:1-96@N,CA,C,O

average avg.$SIMID.crd
average avg.$SIMID.pdb
go
EOF

cp avg.$SIMID.crd /u/sciteam/sean/scratch/EBOLA_2017/TRANSFER/AVG_CRDS
cp avg.$SIMID.pdb /u/sciteam/sean/scratch/EBOLA_2017/TRANSFER/AVG_CRDS
### backup from 5ANALYZE
cd ../

### backup from $SIMID
cd ../
done

### backup from $sim$exp
cd ../
done
done

