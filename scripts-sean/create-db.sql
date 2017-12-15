PRAGMA foreign_keys=off;

BEGIN TRANSACTION;

CREATE TABLE data
( uid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  temporal_name VARCHAR(50) NOT NULL,
  date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  sequence VARCHAR(20) NOT NULL,
  total_score DECIMAL(3,2) NOT NULL,
  total_prot_score DECIMAL(3,2) NOT NULL,
  binding_score DECIMAL(3,2) NOT NULL,
  binding_prot_score DECIMAL(3,2) NOT NULL,
  interface_score DECIMAL(3,2) NOT NULL,
  mmgbsa_chainsABC_peptide1 DECIMAL(3,2) NOT NULL,
  mmgbsa_chainsABC_peptide2 DECIMAL(3,2) NOT NULL,
  mmgbsa_chainsABC_peptide3 DECIMAL(3,2) NOT NULL,
  mmpbsa_chainsABC_peptide1 DECIMAL(3,2) NOT NULL,
  mmpbsa_chainsABC_peptide2 DECIMAL(3,2) NOT NULL,
  mmpbsa_chainsABC_peptide3 DECIMAL(3,2) NOT NULL,
  rms_rec DECIMAL(2,2) NOT NULL,
  rms_lig1 DECIMAL(2,2) NOT NULL,
  rms_lig2 DECIMAL(2,2) NOT NULL,
  rms_lig3 DECIMAL(2,2) NOT NULL,
  rms_lig123 DECIMAL(2,2) NOT NULL,
  distance_1 DECIMAL(2,2) NOT NULL,
  distance_2 DECIMAL(2,2) NOT NULL,
  distance_3 DECIMAL(2,2) NOT NULL,
  rec_para DECIMAL(1,3) NOT NULL,
  rec_anti DECIMAL(1,3) NOT NULL,
  rec_3_10 DECIMAL(1,3) NOT NULL,
  rec_alpha DECIMAL(1,3) NOT NULL,
  rec_pi DECIMAL(1,3) NOT NULL,
  rec_turn DECIMAL(1,3) NOT NULL,
  rec_bend DECIMAL(1,3) NOT NULL,
  lig_para DECIMAL(1,3) NOT NULL,
  lig_anti DECIMAL(1,3) NOT NULL,
  lig_3_10 DECIMAL(1,3) NOT NULL,
  lig_alpha DECIMAL(1,3) NOT NULL,
  lig_pi DECIMAL(1,3) NOT NULL,
  lig_turn DECIMAL(1,3) NOT NULL,
  lig_bend DECIMAL(1,3) NOT NULL,
  native_contacts_lig1 DECIMAL(3,0) NOT NULL,
  native_contacts_lig2 DECIMAL(3,0) NOT NULL,
  native_contacts_lig3 DECIMAL(3,0) NOT NULL
);

COMMIT;

PRAGMA foreign_keys=on;
