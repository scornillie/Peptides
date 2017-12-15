#!/bin/bash
for exp in a;
do

#for sim in {a..k};
for sim in a;
do
DIRECTORY=$exp$sim
cd $DIRECTORY

#for SIMID in */;
for SIMID in "aa.yxszEAPBv"
do
cd $SIMID

### Insert temoporal name to DB
$SCRIPTS/insert.py $DB $SIMID init 0 0

cd 2build
### Insert sequence to DB
$SCRIPTS/insert.py $DB $SIMID update sequence $(awk {'print $2'} data.spec)

### Insert rosetta scores to DB
$SCRIPTS/insert.py $DB $SIMID update total_score $(awk {'print $38'} data.spec)
$SCRIPTS/insert.py $DB $SIMID update total_prot_score $(awk {'print $40'} data.spec)
$SCRIPTS/insert.py $DB $SIMID update binding_score $(awk {'print $42'} data.spec)
$SCRIPTS/insert.py $DB $SIMID update binding_prot_score $(awk {'print $44'} data.spec)
$SCRIPTS/insert.py $DB $SIMID update interface_score $(awk {'print $46'} data.spec)
cd ../

cd 5ANALYZE
### Insert values to DB
$SCRIPTS/insert.py $DB $SIMID update rms_rec $($SCRIPTS/avg.sh rms.rec.dat line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update rms_lig1 $($SCRIPTS/avg.sh rms.lig1.dat line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update rms_lig2 $($SCRIPTS/avg.sh rms.lig2.dat line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update rms_lig3 $($SCRIPTS/avg.sh rms.lig3.dat line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update rms_lig123 $($SCRIPTS/avg.sh rms.lig123.dat line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update distance_1 $($SCRIPTS/avg.sh dist.1.dat line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update distance_2 $($SCRIPTS/avg.sh dist.2.dat line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update distance_3 $($SCRIPTS/avg.sh dist.3.dat line |awk {'print $1'})

$SCRIPTS/insert.py $DB $SIMID update rec_para $($SCRIPTS/avg.sh dssp.rec.dat 2 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update rec_anti $($SCRIPTS/avg.sh dssp.rec.dat 3 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update rec_3_10 $($SCRIPTS/avg.sh dssp.rec.dat 4 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update rec_alpha $($SCRIPTS/avg.sh dssp.rec.dat 5 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update rec_pi $($SCRIPTS/avg.sh dssp.rec.dat 6 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update rec_turn $($SCRIPTS/avg.sh dssp.rec.dat 7 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update rec_bend $($SCRIPTS/avg.sh dssp.rec.dat 8 line |awk {'print $1'})

$SCRIPTS/insert.py $DB $SIMID update lig_para $($SCRIPTS/avg.sh dssp.lig123.dat 2 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update lig_anti $($SCRIPTS/avg.sh dssp.lig123.dat 3 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update lig_3_10 $($SCRIPTS/avg.sh dssp.lig123.dat 4 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update lig_alpha $($SCRIPTS/avg.sh dssp.lig123.dat 5 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update lig_pi $($SCRIPTS/avg.sh dssp.lig123.dat 6 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update lig_turn $($SCRIPTS/avg.sh dssp.lig123.dat 7 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update lig_bend $($SCRIPTS/avg.sh dssp.lig123.dat 8 line |awk {'print $1'})

$SCRIPTS/insert.py $DB $SIMID update native_contacts_lig1 $($SCRIPTS/avg.sh nc.lig1.dat 3 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update native_contacts_lig2 $($SCRIPTS/avg.sh nc.lig2.dat 3 line |awk {'print $1'})
$SCRIPTS/insert.py $DB $SIMID update native_contacts_lig3 $($SCRIPTS/avg.sh nc.lig3.dat 3 line |awk {'print $1'})



### Insert GB energy values to DB ###

cd chainsABC-lig1
$SCRIPTS/insert.py $DB $SIMID update mmgbsa_chainsABC_peptide1 $(awk 'FNR == 114 {print $3}' FINAL.dat)
$SCRIPTS/insert.py $DB $SIMID update mmpbsa_chainsABC_peptide1 $(awk 'FNR == 196 {print $3}' FINAL.dat)
cd ../

cd chainsABC-lig2
$SCRIPTS/insert.py $DB $SIMID update mmgbsa_chainsABC_peptide2 $(awk 'FNR == 114 {print $3}' FINAL.dat)
$SCRIPTS/insert.py $DB $SIMID update mmpbsa_chainsABC_peptide2 $(awk 'FNR == 196 {print $3}' FINAL.dat)
cd ../

cd chainsABC-lig3
$SCRIPTS/insert.py $DB $SIMID update mmgbsa_chainsABC_peptide3 $(awk 'FNR == 114 {print $3}' FINAL.dat)
$SCRIPTS/insert.py $DB $SIMID update mmpbsa_chainsABC_peptide3 $(awk 'FNR == 196 {print $3}' FINAL.dat)
cd ../

### backout from 5ANALYZE
cd ../
### backout from SIMID
cd ../
done
### backout from series aa ab ac ad....etc
cd ../
done
done
