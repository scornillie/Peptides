#!/bin/bash

set -x

source /u/sciteam/sean/amber14/amber.sh

CPPTRAJ=/u/sciteam/sean/amber14/bin/cpptraj
PARMED=/u/sciteam/sean/amber14/bin/parmed.py
LEAP=/u/sciteam/sean/amber14/bin/tleap

### Build-specific. Don't change this. ###
FIELD='$5'

### Set number of lig, rec, & complex ###
TOTAL_RES="1-96"
REC_RES="1-21"

source /u/sciteam/sean/amber14/amber.sh


sed -i 's/CYD/CYX/g' peptide.pdb
sed -i 's/HIS/HIE/g' peptide.pdb

sed -i 's/DAL/ALA/g' peptide.pdb
sed -i 's/DAR/ARG/g' peptide.pdb
sed -i 's/DAN/ASN/g' peptide.pdb
sed -i 's/DAS/ASP/g' peptide.pdb
sed -i 's/DCY/CYS/g' peptide.pdb
sed -i 's/DGN/GLN/g' peptide.pdb
sed -i 's/DGU/GLU/g' peptide.pdb
sed -i 's/GLY/GLY/g' peptide.pdb
sed -i 's/DHI/HIE/g' peptide.pdb
sed -i 's/DIL/ILE/g' peptide.pdb

sed -i 's/DLE/LEU/g' peptide.pdb
sed -i 's/DLY/LYS/g' peptide.pdb
sed -i 's/MED/MET/g' peptide.pdb
sed -i 's/DPH/PHE/g' peptide.pdb
sed -i 's/DPR/PRO/g' peptide.pdb
sed -i 's/DSN/SER/g' peptide.pdb
sed -i 's/DTH/THR/g' peptide.pdb
sed -i 's/DTR/TRP/g' peptide.pdb
sed -i 's/DTY/TYR/g' peptide.pdb
sed -i 's/DVA/VAL/g' peptide.pdb

sed -i '/1H/d' peptide.pdb
sed -i '/2H/d' peptide.pdb
sed -i '/3H/d' peptide.pdb

sleep 10

### Split noH.pdb into three separate pieces D-A + B + C for the purposes of building back in two additional peptide ligands to reach a 3:1 stoichiometry ###
### A=Helix1 B=Helix2 C=Helix3 D=PeptideLigand ###
awk '$5 == "A"' peptide.pdb > peptide.AG.pdb
awk '$5 == "G"' peptide.pdb >> peptide.AG.pdb
awk '$5 == "B"' peptide.pdb > peptide.B.pdb
awk '$5 == "C"' peptide.pdb > peptide.C.pdb

sleep 10

### Build each of the new  PDBs in LEaP ###
cat > build.AG.leap << EOF
source leaprc.ff14SB

PDB = loadpdb peptide.AG.pdb

saveamberparm PDB peptide.iv.AG.prmtop peptide.iv.AG.inpcrd
savepdb PDB peptide.iv.AG.pdb
quit
EOF

sleep 5

$LEAP -f build.AG.leap

sleep 5

###

cat > build.B.leap << EOF
source leaprc.ff14SB
source leaprc.gaff

PDB = loadpdb peptide.B.pdb

saveamberparm PDB peptide.iv.B.prmtop peptide.iv.B.inpcrd
savepdb PDB peptide.iv.B.pdb
quit
EOF

sleep 5

$LEAP -f build.B.leap

sleep 5

###

cat > build.C.leap << EOF
source leaprc.ff14SB
source leaprc.gaff

PDB = loadpdb peptide.C.pdb

saveamberparm PDB peptide.iv.C.prmtop peptide.iv.C.inpcrd
savepdb PDB peptide.iv.C.pdb
quit
EOF

sleep 5

$LEAP -f build.C.leap

sleep 5

### RMS fit our three pieces into place and combine the coordinates into a new mol2 ###
cat > RMS-crds.cpptraj << EOF
parm peptide.iv.AG.prmtop [parmAG]
parm peptide.iv.B.prmtop [parmB]
parm peptide.iv.C.prmtop [parmC]

loadcrd peptide.iv.AG.inpcrd parm [parmAG] AG
loadcrd peptide.iv.B.inpcrd  parm [parmB]  B
loadcrd peptide.iv.C.inpcrd  parm [parmC]  C

# Fit AG onto B, remove A = E
loadcrd peptide.iv.AG.inpcrd parm [parmAG] E
reference peptide.iv.B.inpcrd [refB] parm [parmB]
crdaction E rms ref [refB] :$REC_RES
crdaction E strip :$REC_RES

# Fit AG onto C, remove A = F
loadcrd peptide.iv.AG.inpcrd parm [parmAG] F
reference peptide.iv.C.inpcrd [refC] parm [parmC]
crdaction F rms ref [refC] :$REC_RES
crdaction F strip :$REC_RES

combinecrd AG B E C F crdname AGBECF
crdout AGBECF peptide.iv.AGBECF.mol2
EOF

sleep 5

$CPPTRAJ -i RMS-crds.cpptraj

sleep 5

### Build our now combined systems with LEaP ###
# HIV systems need 60 ions for 0.2M conc #
# Truncated ebola systems need 23 ions for 0.2M conc. #
cat > build.leap << EOF
source leaprc.ff14SB
source leaprc.gaff

MOL = loadmol2 peptide.iv.AGBECF.mol2

saveamberparm MOL peptide.iv.prmtop peptide.iv.inpcrd

solvateoct MOL TIP3PBOX 10.0

saveAmberParm MOL peptide.tip3p.prmtop peptide.tip3p.inpcrd

ionparams = loadamberparams frcmod.ionsjc_tip3p
addions MOL Na+ 0
addions MOL Cl- 0
saveAmberParm MOL peptide.tip3p.neutral.prmtop peptide.tip3p.neutral.inpcrd

addions MOL Na+ 23 Cl- 23
saveAmberParm MOL peptide.tip3p.200mM.prmtop peptide.tip3p.200mM.inpcrd

quit
EOF

sleep 5

$LEAP -f build.leap

sleep 5

### Randomize ions arount your now set res variable using CPPTRAJ ###
# Truncated ebola systems total 105 residues including 3x peptide ligands #
cat > rand.cpptraj << EOF
parm peptide.tip3p.200mM.prmtop
trajin peptide.tip3p.200mM.inpcrd
randomizeions @Na+ around :$TOTAL_RES by 5.0 overlap 3.5
randomizeions @Cl- around :$TOTAL_RES by 5.0 overlap 3.5
trajout peptide.tip3p.rand.inpcrd restart
go
quit
EOF

sleep 5

$CPPTRAJ -i rand.cpptraj

sleep 5

### Repartition hydrogen masses using Parmed to allow for larger timestep 0.002-->0.004 ###
cat > hmass.parmed << EOF
parm peptide.tip3p.200mM.prmtop
HMassRepartition
parmout peptide.tip3p.200mM.hmass.prmtop
go
quit
EOF

sleep 5

$PARMED -i hmass.parmed

sleep 5

cp peptide.tip3p.200mM.hmass.prmtop ../
cp peptide.tip3p.rand.inpcrd ../

sleep 10

exit 0
