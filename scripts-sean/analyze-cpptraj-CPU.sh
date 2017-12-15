#!/bin/bash

AMBERHOME="/projects/sciteam/gk4/amber-pgi"

###################################
##       strip trajectories      ##
###################################
$AMBERHOME/bin/cpptraj <<EOF
parm ../peptide.tip3p.200mM.hmass.prmtop
trajin ../4MD/traj.nc

autoimage
strip :WAT,Na+,Cl-
rms fit :1-21,33-53,65-85
trajout vacuo.nc
go
EOF

$AMBERHOME/bin/cpptraj <<EOF
parm ../peptide.tip3p.200mM.hmass.prmtop
parmstrip :WAT,Na+,Cl-
parmwrite out vacuo.topo
go
EOF

$AMBERHOME/bin/cpptraj <<EOF
parm vacuo.topo
trajin vacuo.nc lastframe
trajout vacuo.pdb pdb
go
EOF

sleep 2

###################################
##        Data Analysis          ##
###################################
$AMBERHOME/bin/cpptraj <<EOF
parm vacuo.topo
trajin vacuo.nc
autoimage
average avg.crd
go
EOF

sleep 2

$AMBERHOME/bin/cpptraj <<EOF
parm vacuo.topo
trajin vacuo.nc

rms fit :1-21,33-53,65-85 mass

reference avg.crd [avg]

### RMSD Analyses
rms rms1 :1-21,33-53,65-85&!@H= reference :1-21,33-53,65-85&!@H= mass out rms.rec.dat time 10
hist rms1 norm min 0 max 6 bins 200 out rms.rec.hist

rms rms2 :22-32&!@H= reference :22-32&!@H= mass out rms.lig1.dat time 10
hist rms2 norm min 0 max 6 bins 200 out rms.lig.1.hist

rms rms3 :54-64&!@H= reference :54-64&!@H= mass out rms.lig2.dat time 10
hist rms3 norm min 0 max 6 bins 200 out rms.lig.2.hist

rms rms4 :86-96&!@H= reference :86-96&!@H= mass out rms.lig3.dat time 10
hist rms4 norm min 0 max 6 bins 200 out rms.lig.3.hist

rms rms5 :22-32,54-64,86-96&!@H= reference :22-32,54-64,86-96&!@H= mass out rms.lig123.dat time 10
hist rms5 norm min 0 max 6 bins 200 out rms.lig.123.hist

### Lig:Rec Distance
distance d1 :25@CA :37@CA out dist.1.dat
hist d1 norm min 0 max 20 bins 200 out dist.1.hist
distance d2 :57@CA :69@CA out dist.2.dat
hist d2 norm min 0 max 20 bins 200 out dist.2.hist
distance d3 :89@CA :5@CA out dist.3.dat
hist d3 norm min 0 max 20 bins 200 out dist.3.hist


### DSSP Analysis of secondary structure
secstruct :1-21,33-53,65-85 out dssp.rec.gnu sumout dssp.rec.agr totalout dssp.rec.dat
secstruct :22-32 out dssp.lig1.gnu sumout dssp.lig1.agr totalout dssp.lig1.dat
secstruct :54-64 out dssp.lig2.gnu sumout dssp.lig2.agr totalout dssp.lig2.dat
secstruct :86-96 out dssp.lig3.gnu sumout dssp.lig3.agr totalout dssp.lig3.dat
secstruct :22-32,54-64,86-96 out dssp.lig123.gnu sumout dssp.lig123.agr totalout dssp.lig123.dat


### Native contacts lig1
nativecontacts :1-21,33-53&!@H= :22-32&!@H= byresidue \
    out nc.lig1.dat series seriesout nc.lig1.series.dat distance 6.0 \
    map mapout nc.lig1.resmap.gnu contactpdb nc.lig1.pdb

### Native contacts lig2
nativecontacts :33-53,65-85&!@H= :54-64&!@H= byresidue \
    out nc.lig2.dat series seriesout nc.lig2.series.dat distance 6.0 \
    map mapout nc.lig2.resmap.gnu contactpdb nc.lig2.pdb

### Native contacts lig3
nativecontacts :1-21,65-85&!@H= :86-96&!@H= byresidue \
    out nc.lig3.dat series seriesout nc.lig3.series.dat distance 6.0 \
    map mapout nc.lig3.resmap.gnu contactpdb nc.lig3.pdb


### Radius of Gyration
radgyr :1-96&!@H= out RoG.lig_rec.dat mass nomax
radgyr :1-21,33-53,65-85&!@H= out RoG.rec.dat mass nomax
radgyr :22-32,54-64,86-96&!@H= out RoG.lig123.dat mass nomax

go
EOF
sleep 2
exit 0
