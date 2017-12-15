PRAGMA foreign_keys=off;

BEGIN TRANSACTION;

CREATE TABLE data
( uid INTEGER PRIMARY KEY AUTOINCREMENT,
  temporal_name VARCHAR,
  date DATETIME DEFAULT CURRENT_TIMESTAMP,
  sequence VARCHAR,
  total_score DECIMAL(3,2),
  total_prot_score DECIMAL(3,2),
  binding_score DECIMAL(3,2),
  binding_prot_score DECIMAL(3,2),
  interface_score DECIMAL(3,2),
  mmgbsa_chainsABC_peptide1 DECIMAL(3,2),
  mmgbsa_chainsABC_peptide2 DECIMAL(3,2),
  mmgbsa_chainsABC_peptide3 DECIMAL(3,2),
  mmpbsa_chainsABC_peptide1 DECIMAL(3,2),
  mmpbsa_chainsABC_peptide2 DECIMAL(3,2),
  mmpbsa_chainsABC_peptide3 DECIMAL(3,2),
  rms_rec DECIMAL(2,2),
  rms_lig1 DECIMAL(2,2),
  rms_lig2 DECIMAL(2,2),
  rms_lig3 DECIMAL(2,2),
  rms_lig123 DECIMAL(2,2),
  distance_1 DECIMAL(2,2),
  distance_2 DECIMAL(2,2),
  distance_3 DECIMAL(2,2),
  rec_para DECIMAL(1,3),
  rec_anti DECIMAL(1,3),
  rec_3_10 DECIMAL(1,3),
  rec_alpha DECIMAL(1,3),
  rec_pi DECIMAL(1,3),
  rec_turn DECIMAL(1,3),
  rec_bend DECIMAL(1,3),
  lig_para DECIMAL(1,3),
  lig_anti DECIMAL(1,3),
  lig_3_10 DECIMAL(1,3),
  lig_alpha DECIMAL(1,3),
  lig_pi DECIMAL(1,3),
  lig_turn DECIMAL(1,3),
  lig_bend DECIMAL(1,3),
  native_contacts_lig1 DECIMAL(3,0),
  native_contacts_lig2 DECIMAL(3,0),
  native_contacts_lig3 DECIMAL(3,0)
);

COMMIT;

PRAGMA foreign_keys=on;
