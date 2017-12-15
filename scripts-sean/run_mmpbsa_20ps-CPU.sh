#!/bin/bash
source /u/sciteam/sean/amber14/amber.sh

AMBERHOME=/u/sciteam/sean/amber14
SCRIPTS=/u/sciteam/sean/scratch/EBOLA_2017/scripts-sean

#########################################
##        MMPBSA for ligand1           ##
#########################################
mkdir chainsABC-lig1_20ps
cd chainsABC-lig1_20ps

#$AMBERHOME/bin/cpptraj<<EOF
#parm ../vacuo.topo
#trajin ../vacuo.nc
#strip :54-64,86-96
#trajout stripped.nc nobox
#go
#clear all
#parm ../vacuo.topo
#parmstrip :54-64,86-96
#parmbox nobox
#parmwrite out stripped.topo
#go
#EOF

#$AMBERHOME/bin/ante-MMPBSA.py -p stripped.topo -c c.topo -r r.topo -l l.topo -n :22-32 -s :WAT,Na+,Cl-

$AMBERHOME/bin/MMPBSA.py -O -i $SCRIPTS/mmpbsa.20ps.in \
    -o FINAL_rep.dat -eo FINAL_rep.csv \
    -cp ../chainsABC-lig1/stripped.topo \
    -sp ../chainsABC-lig1/stripped.topo \
    -rp ../chainsABC-lig1/r.topo \
    -lp ../chainsABC-lig1/l.topo \
    -y ../chainsABC-lig1/stripped.nc

cd ../

#########################################
##        MMPBSA for ligand2           ##
#########################################
mkdir chainsABC-lig2_20ps
cd chainsABC-lig2_20ps

#$AMBERHOME/bin/cpptraj<<EOF
#parm ../vacuo.topo
#trajin ../vacuo.nc
#strip :22-32,86-96
#trajout stripped.nc nobox
#go
#clear all
#parm ../vacuo.topo
#parmstrip :22-32,86-96
#parmbox nobox
#parmwrite out stripped.topo
#go
#EOF

#$AMBERHOME/bin/ante-MMPBSA.py -p stripped.topo -c c.topo -r r.topo -l l.topo -n :43-53 -s :WAT,Na+,Cl-

$AMBERHOME/bin/MMPBSA.py -O -i $SCRIPTS/mmpbsa.20ps.in \
    -o FINAL_rep.dat -eo FINAL_rep.csv \
    -cp ../chainsABC-lig2/stripped.topo \
    -sp ../chainsABC-lig2/stripped.topo \
    -rp ../chainsABC-lig2/r.topo \
    -lp ../chainsABC-lig2/l.topo \
    -y ../chainsABC-lig2/stripped.nc

cd ../

#########################################
##        MMPBSA for ligand3           ##
#########################################
mkdir chainsABC-lig3_20ps
cd chainsABC-lig3_20ps

#$AMBERHOME/bin/cpptraj<<EOF
#parm ../vacuo.topo
#trajin ../vacuo.nc
#strip :22-32,54-64
#trajout stripped.nc nobox
#go
#clear all
#parm ../vacuo.topo
#parmstrip :22-32,54-64
#parmbox nobox
#parmwrite out stripped.topo
#go
#EOF

#$AMBERHOME/bin/ante-MMPBSA.py -p stripped.topo -c c.topo -r r.topo -l l.topo -n :64-74 -s :WAT,Na+,Cl-

$AMBERHOME/bin/MMPBSA.py -O -i $SCRIPTS/mmpbsa.20ps.in \
    -o FINAL_rep.dat -eo FINAL_rep.csv \
    -cp ../chainsABC-lig3/stripped.topo \
    -sp ../chainsABC-lig3/stripped.topo \
    -rp ../chainsABC-lig3/r.topo \
    -lp ../chainsABC-lig3/l.topo \
    -y ../chainsABC-lig3/stripped.nc

cd ../

exit 0
