#!/bin/bash
source /u/sciteam/sean/amber14/amber.sh

AMBERHOME=/u/sciteam/sean/amber14
SCRIPTS=/u/sciteam/sean/scratch/EBOLA_2017/scripts-sean

#########################################
##        MMPBSA for ligand1           ##
#########################################
#mkdir chainsABC-lig1
cd chainsABC-lig1

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

$AMBERHOME/bin/MMPBSA.py -O -i $SCRIPTS/mmpbsa-decomp.in \
    -o FINAL_rep.dat -eo FINAL_rep.csv \
    -do FINAL_DECOMP.dat -deo FINAL_DECOMP.csv \
    -cp stripped.topo \
    -sp stripped.topo \
    -rp r.topo \
    -lp l.topo \
    -y stripped.nc

cd ../

#########################################
##        MMPBSA for ligand2           ##
#########################################
#mkdir chainsABC-lig2
cd chainsABC-lig2

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

$AMBERHOME/bin/MMPBSA.py -O -i $SCRIPTS/mmpbsa-decomp.in \
    -o FINAL_rep.dat -eo FINAL_rep.csv \
    -do FINAL_DECOMP.dat -deo FINAL_DECOMP.csv \
    -cp stripped.topo \
    -sp stripped.topo \
    -rp r.topo \
    -lp l.topo \
    -y stripped.nc

cd ../

#########################################
##        MMPBSA for ligand3           ##
#########################################
#mkdir chainsABC-lig3
cd chainsABC-lig3

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

$AMBERHOME/bin/MMPBSA.py -O -i $SCRIPTS/mmpbsa-decomp.in \
    -o FINAL_rep.dat -eo FINAL_rep.csv \
    -do FINAL_DECOMP.dat -deo FINAL_DECOMP.csv \
    -cp stripped.topo \
    -sp stripped.topo \
    -rp r.topo \
    -lp l.topo \
    -y stripped.nc

cd ../

exit 0
