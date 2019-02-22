
/* */
/****************************************************************************
Code to create tables from NHS data ready to be imported into Tableau for dashboard anaylsis
Tables made:
admit_table: contains HRG codes, 17/18 prices, 18/19 prices, change in price and % change in price
non_elec_tariff_table: as above but for non-elective procedures
admit_stats_table: min, max and average price changes
admit_stats_chap_table: min, max and average price changes BY CHAPTER
butterfly_table: data manipulated for butterfly table in tableau
outpatients_table: data regarding outpatient information

NOTE: Tables after admit_table require admit_table to already exist
*****************************************************************************/

/* admit_table */
drop table admit_table
select
	p78.[HRG code] as HRGcode
	,left((p78.[HRG code]),1) as ChapterCode
	,case
		when left((p78.[HRG code]),1) like 'A' then 'Nervous System'
		when left((p78.[HRG code]),1) like 'B' then 'Eyes and Periorbita'
		when left((p78.[HRG code]),1) like 'C' then 'Mouth, Head, Neck and Ears'
		when left((p78.[HRG code]),1) like 'D' then 'Respiratory System'
		when left((p78.[HRG code]),1) like 'E' then 'Cardiac Syrgery and Primary Cardiac Condition'
		when left((p78.[HRG code]),1) like 'F' then 'Digestive System'
		when left((p78.[HRG code]),1) like 'G' then 'Hepatobiliary and Pancreatic System'
		when left((p78.[HRG code]),1) like 'H' then 'Musculoskeletal System'
		when left((p78.[HRG code]),1) like 'J' then 'Skin, Breast and burns'
		when left((p78.[HRG code]),1) like 'K' then 'Endocrine and Metabolic System'
		when left((p78.[HRG code]),1) like 'L' then 'Urinary Tract and Male Reproductive System'
		when left((p78.[HRG code]),1) like 'M' then 'Female Reproductive System and Assisted Reproduction'
		when left((p78.[HRG code]),1) like 'N' then 'Obstetrics'
		when left((p78.[HRG code]),1) like 'P' then 'Diseases of Childhood and Neonates'
		when left((p78.[HRG code]),1) like 'Q' then 'Vascular System'
		when left((p78.[HRG code]),1) like 'R' then 'Radiology and Nuclear Medicine'
		when left((p78.[HRG code]),1) like 'S' then 'Haematology, Chemotherapy, Radiotherapy and Specialist Palliative Care'
		when left((p78.[HRG code]),1) like 'U' then 'Undefined Groups'
		when left((p78.[HRG code]),1) like 'V' then 'Multiple Trauma, Emergency Medicine and Rehabilitation'
		when left((p78.[HRG code]),1) like 'W' then 'Immunology, Infectious Diseases and Other Contacts with Health Services'
		when left((p78.[HRG code]),1) like 'X' then 'Critical Care and High Cost Drugs'
	end as DiagnosisChapter
	,left((p78.[HRG code]),2) as SubChapterCode
	,case
		when left((p78.[HRG code]),2) like 'AA' then 'Nervous System Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'AB' then 'Pain Management'
		when left((p78.[HRG code]),2) like 'BZ' then 'Eyes and Periorbita Procedures and Disorders '
		when left((p78.[HRG code]),2) like 'CZ' then 'Mouth Head Neck and Ears Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'DZ' then 'Thoracic Procedures and disorders'
		when left((p78.[HRG code]),2) like 'EA' then 'Cardiac Procedures'
		when left((p78.[HRG code]),2) like 'EB' then 'Cardiac Disorders'
		when left((p78.[HRG code]),2) like 'FA' then 'Digestive System Surgery'
		when left((p78.[HRG code]),2) like 'FB' then 'Digestive System Endoscopies'
		when left((p78.[HRG code]),2) like 'FC' then 'Gastroenterology Medicine'
		when left((p78.[HRG code]),2) like 'GA' then 'Hepatobiliary and Pancreatic System Surgery'
		when left((p78.[HRG code]),2) like 'GB' then 'Hepatobiliary and Pancreatic System Endoscopies and Radiological Procedures' 
		when left((p78.[HRG code]),2) like 'GC' then 'Hepatobiliary and Pancreatic System Disorders'
		when left((p78.[HRG code]),2) like 'HA' then 'Orthopaedic Trauma Procedures & Reconstruction'
		when left((p78.[HRG code]),2) like 'HB' then 'Orthopaedic Non-Trauma Procedures'
		when left((p78.[HRG code]),2) like 'HC' then 'Spinal Surgery and Disorders'
		when left((p78.[HRG code]),2) like 'HD' then 'Musculoskeletal Disorders'
		when left((p78.[HRG code]),2) like 'JA' then 'Breast Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'JB' then 'Burns Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'JC' then 'Skin Surgery'
		when left((p78.[HRG code]),2) like 'JD' then 'Skin Disorders'
		when left((p78.[HRG code]),2) like 'KA' then 'Endocrine System Disorders'
		when left((p78.[HRG code]),2) like 'KB' then 'Diabetic Medicine'
		when left((p78.[HRG code]),2) like 'KC' then 'Metabolic Disorders'
		when left((p78.[HRG code]),2) like 'LA' then 'Renal Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'LB' then 'Urological Procedures and Disorders' 
		when left((p78.[HRG code]),2) like 'MA' then 'Female Reproductive System Procedures' 
		when left((p78.[HRG code]),2) like 'MB' then 'Female Reproductive System Disorders'
		when left((p78.[HRG code]),2) like 'MC' then 'Assisted Reproduction Medicine'
		when left((p78.[HRG code]),2) like 'NZ' then 'Obstetric Medicine'
		when left((p78.[HRG code]),2) like 'PA' then 'Paediatric Medicine'
		when left((p78.[HRG code]),2) like 'PB' then 'Neonatal Disorders'
		when left((p78.[HRG code]),2) like 'QZ' then 'Vascular Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'RA' then 'Imaging Procedures'
		when left((p78.[HRG code]),2) like 'RB' then 'Interventional Radiological Procedures'
		when left((p78.[HRG code]),2) like 'SA' then 'Haematological Disorders'
		when left((p78.[HRG code]),2) like 'SB' then 'Chemotherapy'
		when left((p78.[HRG code]),2) like 'SC' then 'Radiotherapy'
		when left((p78.[HRG code]),2) like 'SD' then 'Specialist Palliative Care'
		when left((p78.[HRG code]),2) like 'UZ' then 'Data Invalid for Grouping'
		when left((p78.[HRG code]),2) like 'VA' then 'Multiple Trauma'
		when left((p78.[HRG code]),2) like 'VB' then 'Emergency and Urgent Care'
		when left((p78.[HRG code]),2) like 'VC' then 'Rehabilitation'
		when left((p78.[HRG code]),2) like 'WA' then 'Immunology, infectious diseases, poisoning, shock, special examinations, screening and other healthcare contacts'
		when left((p78.[HRG code]),2) like 'WD' then 'Treatment of Mental Health patients by non Mental Health providers'
		when left((p78.[HRG code]),2) like 'WE' then 'Genito-Urinary Medicine'
		when left((p78.[HRG code]),2) like 'WF' then 'Non-admitted consultations'
		when left((p78.[HRG code]),2) like 'WG' then 'Reserved for Pathology'
		when left((p78.[HRG code]),2) like 'XA' then 'Reserved for Neonatal Critical Care'
		when left((p78.[HRG code]),2) like 'XB' then 'Paediatric Critical Care'
		when left((p78.[HRG code]),2) like 'XC' then 'Adult Critical Care'
		when left((p78.[HRG code]),2) like 'XD' then 'High Cost Drugs'
		when left((p78.[HRG code]),2) like 'ZZ' then 'Unbundling HRG'
	end as DiagnosisSubChapter
	,p78.[Combined day case / ordinary elective spell tariff (£)] as OldPrice
	,p89.[Combined day case / ordinary elective spell tariff (£)] as NewPrice
	,round(p89.[Combined day case / ordinary elective spell tariff (£)] - p78.[Combined day case / ordinary elective spell tariff (£)],0) as Increase
	,round((((nullif(p89.[Combined day case / ordinary elective spell tariff (£)],0) - nullif(p78.[Combined day case / ordinary elective spell tariff (£)],0))/nullif(p78.[Combined day case / ordinary elective spell tariff (£)],0)) *100),2) as PercentageChange
	,round((((nullif(p89.[Combined day case / ordinary elective spell tariff (£)],0) - nullif(p78.[Combined day case / ordinary elective spell tariff (£)],0))/nullif(p78.[Combined day case / ordinary elective spell tariff (£)],0)) *100),1) as PerchangeNearest10
into admit_table
from [healthcare].[stage].[admitted1718] p78
left join [healthcare].[stage].[admitted1819] p89
on p78.[HRG code] = p89.[HRG code]

select top 10 * from admit_table

/*****************************************************************************************************************************************************************/
/* Non-Elec Tariff Table*/
select
	p78.[HRG code] as HRGcode
	,left((p78.[HRG code]),1) as ChapterCode
	,case
		when left((p78.[HRG code]),1) like 'A' then 'Nervous System'
		when left((p78.[HRG code]),1) like 'B' then 'Eyes and Periorbita'
		when left((p78.[HRG code]),1) like 'C' then 'Mouth, Head, Neck and Ears'
		when left((p78.[HRG code]),1) like 'D' then 'Respiratory System'
		when left((p78.[HRG code]),1) like 'E' then 'Cardiac Syrgery and Primary Cardiac Condition'
		when left((p78.[HRG code]),1) like 'F' then 'Digestive System'
		when left((p78.[HRG code]),1) like 'G' then 'Hepatobiliary and Pancreatic System'
		when left((p78.[HRG code]),1) like 'H' then 'Musculoskeletal System'
		when left((p78.[HRG code]),1) like 'J' then 'Skin, Breast and burns'
		when left((p78.[HRG code]),1) like 'K' then 'Endocrine and Metabolic System'
		when left((p78.[HRG code]),1) like 'L' then 'Urinary Tract and Male Reproductive System'
		when left((p78.[HRG code]),1) like 'M' then 'Female Reproductive System and Assisted Reproduction'
		when left((p78.[HRG code]),1) like 'N' then 'Obstetrics'
		when left((p78.[HRG code]),1) like 'P' then 'Diseases of Childhood and Neonates'
		when left((p78.[HRG code]),1) like 'Q' then 'Vascular System'
		when left((p78.[HRG code]),1) like 'R' then 'Radiology and Nuclear Medicine'
		when left((p78.[HRG code]),1) like 'S' then 'Haematology, Chemotherapy, Radiotherapy and Specialist Palliative Care'
		when left((p78.[HRG code]),1) like 'U' then 'Undefined Groups'
		when left((p78.[HRG code]),1) like 'V' then 'Multiple Trauma, Emergency Medicine and Rehabilitation'
		when left((p78.[HRG code]),1) like 'W' then 'Immunology, Infectious Diseases and Other Contacts with Health Services'
		when left((p78.[HRG code]),1) like 'X' then 'Critical Care and High Cost Drugs'
	end as DiagnosisChapter
	,left((p78.[HRG code]),2) as SubChapterCode
	,case
		when left((p78.[HRG code]),2) like 'AA' then 'Nervous System Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'AB' then 'Pain Management'
		when left((p78.[HRG code]),2) like 'BZ' then 'Eyes and Periorbita Procedures and Disorders '
		when left((p78.[HRG code]),2) like 'CZ' then 'Mouth Head Neck and Ears Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'DZ' then 'Thoracic Procedures and disorders'
		when left((p78.[HRG code]),2) like 'EA' then 'Cardiac Procedures'
		when left((p78.[HRG code]),2) like 'EB' then 'Cardiac Disorders'
		when left((p78.[HRG code]),2) like 'FA' then 'Digestive System Surgery'
		when left((p78.[HRG code]),2) like 'FB' then 'Digestive System Endoscopies'
		when left((p78.[HRG code]),2) like 'FC' then 'Gastroenterology Medicine'
		when left((p78.[HRG code]),2) like 'GA' then 'Hepatobiliary and Pancreatic System Surgery'
		when left((p78.[HRG code]),2) like 'GB' then 'Hepatobiliary and Pancreatic System Endoscopies and Radiological Procedures' 
		when left((p78.[HRG code]),2) like 'GC' then 'Hepatobiliary and Pancreatic System Disorders'
		when left((p78.[HRG code]),2) like 'HA' then 'Orthopaedic Trauma Procedures & Reconstruction'
		when left((p78.[HRG code]),2) like 'HB' then 'Orthopaedic Non-Trauma Procedures'
		when left((p78.[HRG code]),2) like 'HC' then 'Spinal Surgery and Disorders'
		when left((p78.[HRG code]),2) like 'HD' then 'Musculoskeletal Disorders'
		when left((p78.[HRG code]),2) like 'JA' then 'Breast Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'JB' then 'Burns Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'JC' then 'Skin Surgery'
		when left((p78.[HRG code]),2) like 'JD' then 'Skin Disorders'
		when left((p78.[HRG code]),2) like 'KA' then 'Endocrine System Disorders'
		when left((p78.[HRG code]),2) like 'KB' then 'Diabetic Medicine'
		when left((p78.[HRG code]),2) like 'KC' then 'Metabolic Disorders'
		when left((p78.[HRG code]),2) like 'LA' then 'Renal Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'LB' then 'Urological Procedures and Disorders' 
		when left((p78.[HRG code]),2) like 'MA' then 'Female Reproductive System Procedures' 
		when left((p78.[HRG code]),2) like 'MB' then 'Female Reproductive System Disorders'
		when left((p78.[HRG code]),2) like 'MC' then 'Assisted Reproduction Medicine'
		when left((p78.[HRG code]),2) like 'NZ' then 'Obstetric Medicine'
		when left((p78.[HRG code]),2) like 'PA' then 'Paediatric Medicine'
		when left((p78.[HRG code]),2) like 'PB' then 'Neonatal Disorders'
		when left((p78.[HRG code]),2) like 'QZ' then 'Vascular Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'RA' then 'Imaging Procedures'
		when left((p78.[HRG code]),2) like 'RB' then 'Interventional Radiological Procedures'
		when left((p78.[HRG code]),2) like 'SA' then 'Haematological Disorders'
		when left((p78.[HRG code]),2) like 'SB' then 'Chemotherapy'
		when left((p78.[HRG code]),2) like 'SC' then 'Radiotherapy'
		when left((p78.[HRG code]),2) like 'SD' then 'Specialist Palliative Care'
		when left((p78.[HRG code]),2) like 'UZ' then 'Data Invalid for Grouping'
		when left((p78.[HRG code]),2) like 'VA' then 'Multiple Trauma'
		when left((p78.[HRG code]),2) like 'VB' then 'Emergency and Urgent Care'
		when left((p78.[HRG code]),2) like 'VC' then 'Rehabilitation'
		when left((p78.[HRG code]),2) like 'WA' then 'Immunology, infectious diseases, poisoning, shock, special examinations, screening and other healthcare contacts'
		when left((p78.[HRG code]),2) like 'WD' then 'Treatment of Mental Health patients by non Mental Health providers'
		when left((p78.[HRG code]),2) like 'WE' then 'Genito-Urinary Medicine'
		when left((p78.[HRG code]),2) like 'WF' then 'Non-admitted consultations'
		when left((p78.[HRG code]),2) like 'WG' then 'Reserved for Pathology'
		when left((p78.[HRG code]),2) like 'XA' then 'Reserved for Neonatal Critical Care'
		when left((p78.[HRG code]),2) like 'XB' then 'Paediatric Critical Care'
		when left((p78.[HRG code]),2) like 'XC' then 'Adult Critical Care'
		when left((p78.[HRG code]),2) like 'XD' then 'High Cost Drugs'
		when left((p78.[HRG code]),2) like 'ZZ' then 'Unbundling HRG'
	end as DiagnosisSubChapter
	,p78.[Non-elective spell tariff (£)] as NE_OldPrice
	,p89.[Non-elective spell tariff (£)] as NE_NewPrice
	,round(p89.[Non-elective spell tariff (£)] - p78.[Non-elective spell tariff (£)],0) as NE_Increase
	,round((((nullif(p89.[Non-elective spell tariff (£)],0) - nullif(p78.[Non-elective spell tariff (£)],0))/nullif(p78.[Non-elective spell tariff (£)],0)) *100),2) as NE_PercentageChange
	,round((((nullif(p89.[Non-elective spell tariff (£)],0) - nullif(p78.[Non-elective spell tariff (£)],0))/nullif(p78.[Non-elective spell tariff (£)],0)) *100),1) as NE_PerchangeNearest10
into non_elec_table
from [healthcare].[stage].[admitted1718] p78
left join [healthcare].[stage].[admitted1819] p89
on p78.[HRG code] = p89.[HRG code]


select top 10 * from non_elec_table


/****************************************************************************************************************/
/* admit_stats_table */
drop table admit_stats_table
select
	min(PercentageChange) as MinPercent
	,max(PercentageChange) as MaxPercent
	,round(avg(PercentageChange),2) as AvgPercent
	,min(Increase) as MinChange
	,max(Increase) as MaxChange
	,round(avg(Increase),2) as AvgChange
into admit_stats_table
from admit_table

select * from admit_stats_table


/****************************************************************************************************************/
/* admit_stats_chap_table */
drop table admit_stats_chap_table
select
	ChapterCode
	,min(PercentageChange) as MinPercent
	,max(PercentageChange) as MaxPercent
	,round(avg(PercentageChange),2) as AvgPercent
	,min(Increase) as MinChange
	,max(Increase) as MaxChange
	,round(avg(Increase),2) as AvgChangeDec
	,round(avg(Increase),0) as AvgChange
into admit_stats_chap_table
from admit_table
group by ChapterCode
order by ChapterCode asc

select * from admit_stats_chap_table
order by ChapterCode asc


/*************************************************************************************************/
/*Butterfly Table */
drop table butterfly_table
select 
	at.DiagnosisSubChapter
	,avg(at.PercentageChange) as avgpercent_elec
	,avg(net.NE_PercentageChange) as avgpercent_NE
into butterfly_table
from admit_table at
full outer join non_elec_table net
on at.HRGcode = net.HRGcode
group by at.DiagnosisSubChapter
order by at.DiagnosisSubChapter asc

select * from butterfly_table


/*************************************************************************************************/
/* Sunburst Table */
drop table elec_sunburst_table
select
	DiagnosisChapter
	,DiagnosisSubChapter
	,PercentageChange
into elec_sunburst_table
from admit_table


go
alter table elec_sunburst_table
add [Level] int

go
update elec_sunburst_table
set [Level] = 3

select * from elec_sunburst_table

select top 10 * from admit_table


/*************************************************************************************************/
/* Outpatients Table */

drop table outpatient_table
select
	p78.[HRG code] as HRGcode
	,left((p78.[HRG code]),1) as ChapterCode
	,case
		when left((p78.[HRG code]),1) like 'A' then 'Nervous System'
		when left((p78.[HRG code]),1) like 'B' then 'Eyes and Periorbita'
		when left((p78.[HRG code]),1) like 'C' then 'Mouth, Head, Neck and Ears'
		when left((p78.[HRG code]),1) like 'D' then 'Respiratory System'
		when left((p78.[HRG code]),1) like 'E' then 'Cardiac Syrgery and Primary Cardiac Condition'
		when left((p78.[HRG code]),1) like 'F' then 'Digestive System'
		when left((p78.[HRG code]),1) like 'G' then 'Hepatobiliary and Pancreatic System'
		when left((p78.[HRG code]),1) like 'H' then 'Musculoskeletal System'
		when left((p78.[HRG code]),1) like 'J' then 'Skin, Breast and burns'
		when left((p78.[HRG code]),1) like 'K' then 'Endocrine and Metabolic System'
		when left((p78.[HRG code]),1) like 'L' then 'Urinary Tract and Male Reproductive System'
		when left((p78.[HRG code]),1) like 'M' then 'Female Reproductive System and Assisted Reproduction'
		when left((p78.[HRG code]),1) like 'N' then 'Obstetrics'
		when left((p78.[HRG code]),1) like 'P' then 'Diseases of Childhood and Neonates'
		when left((p78.[HRG code]),1) like 'Q' then 'Vascular System'
		when left((p78.[HRG code]),1) like 'R' then 'Radiology and Nuclear Medicine'
		when left((p78.[HRG code]),1) like 'S' then 'Haematology, Chemotherapy, Radiotherapy and Specialist Palliative Care'
		when left((p78.[HRG code]),1) like 'U' then 'Undefined Groups'
		when left((p78.[HRG code]),1) like 'V' then 'Multiple Trauma, Emergency Medicine and Rehabilitation'
		when left((p78.[HRG code]),1) like 'W' then 'Immunology, Infectious Diseases and Other Contacts with Health Services'
		when left((p78.[HRG code]),1) like 'X' then 'Critical Care and High Cost Drugs'
	end as DiagnosisChapter
	,left((p78.[HRG code]),2) as SubChapterCode
	,case
		when left((p78.[HRG code]),2) like 'AA' then 'Nervous System Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'AB' then 'Pain Management'
		when left((p78.[HRG code]),2) like 'BZ' then 'Eyes and Periorbita Procedures and Disorders '
		when left((p78.[HRG code]),2) like 'CZ' then 'Mouth Head Neck and Ears Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'DZ' then 'Thoracic Procedures and disorders'
		when left((p78.[HRG code]),2) like 'EA' then 'Cardiac Procedures'
		when left((p78.[HRG code]),2) like 'EB' then 'Cardiac Disorders'
		when left((p78.[HRG code]),2) like 'FA' then 'Digestive System Surgery'
		when left((p78.[HRG code]),2) like 'FB' then 'Digestive System Endoscopies'
		when left((p78.[HRG code]),2) like 'FC' then 'Gastroenterology Medicine'
		when left((p78.[HRG code]),2) like 'GA' then 'Hepatobiliary and Pancreatic System Surgery'
		when left((p78.[HRG code]),2) like 'GB' then 'Hepatobiliary and Pancreatic System Endoscopies and Radiological Procedures' 
		when left((p78.[HRG code]),2) like 'GC' then 'Hepatobiliary and Pancreatic System Disorders'
		when left((p78.[HRG code]),2) like 'HA' then 'Orthopaedic Trauma Procedures & Reconstruction'
		when left((p78.[HRG code]),2) like 'HB' then 'Orthopaedic Non-Trauma Procedures'
		when left((p78.[HRG code]),2) like 'HC' then 'Spinal Surgery and Disorders'
		when left((p78.[HRG code]),2) like 'HD' then 'Musculoskeletal Disorders'
		when left((p78.[HRG code]),2) like 'JA' then 'Breast Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'JB' then 'Burns Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'JC' then 'Skin Surgery'
		when left((p78.[HRG code]),2) like 'JD' then 'Skin Disorders'
		when left((p78.[HRG code]),2) like 'KA' then 'Endocrine System Disorders'
		when left((p78.[HRG code]),2) like 'KB' then 'Diabetic Medicine'
		when left((p78.[HRG code]),2) like 'KC' then 'Metabolic Disorders'
		when left((p78.[HRG code]),2) like 'LA' then 'Renal Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'LB' then 'Urological Procedures and Disorders' 
		when left((p78.[HRG code]),2) like 'MA' then 'Female Reproductive System Procedures' 
		when left((p78.[HRG code]),2) like 'MB' then 'Female Reproductive System Disorders'
		when left((p78.[HRG code]),2) like 'MC' then 'Assisted Reproduction Medicine'
		when left((p78.[HRG code]),2) like 'NZ' then 'Obstetric Medicine'
		when left((p78.[HRG code]),2) like 'PA' then 'Paediatric Medicine'
		when left((p78.[HRG code]),2) like 'PB' then 'Neonatal Disorders'
		when left((p78.[HRG code]),2) like 'QZ' then 'Vascular Procedures and Disorders'
		when left((p78.[HRG code]),2) like 'RA' then 'Imaging Procedures'
		when left((p78.[HRG code]),2) like 'RB' then 'Interventional Radiological Procedures'
		when left((p78.[HRG code]),2) like 'SA' then 'Haematological Disorders'
		when left((p78.[HRG code]),2) like 'SB' then 'Chemotherapy'
		when left((p78.[HRG code]),2) like 'SC' then 'Radiotherapy'
		when left((p78.[HRG code]),2) like 'SD' then 'Specialist Palliative Care'
		when left((p78.[HRG code]),2) like 'UZ' then 'Data Invalid for Grouping'
		when left((p78.[HRG code]),2) like 'VA' then 'Multiple Trauma'
		when left((p78.[HRG code]),2) like 'VB' then 'Emergency and Urgent Care'
		when left((p78.[HRG code]),2) like 'VC' then 'Rehabilitation'
		when left((p78.[HRG code]),2) like 'WA' then 'Immunology, infectious diseases, poisoning, shock, special examinations, screening and other healthcare contacts'
		when left((p78.[HRG code]),2) like 'WD' then 'Treatment of Mental Health patients by non Mental Health providers'
		when left((p78.[HRG code]),2) like 'WE' then 'Genito-Urinary Medicine'
		when left((p78.[HRG code]),2) like 'WF' then 'Non-admitted consultations'
		when left((p78.[HRG code]),2) like 'WG' then 'Reserved for Pathology'
		when left((p78.[HRG code]),2) like 'XA' then 'Reserved for Neonatal Critical Care'
		when left((p78.[HRG code]),2) like 'XB' then 'Paediatric Critical Care'
		when left((p78.[HRG code]),2) like 'XC' then 'Adult Critical Care'
		when left((p78.[HRG code]),2) like 'XD' then 'High Cost Drugs'
		when left((p78.[HRG code]),2) like 'ZZ' then 'Unbundling HRG'
	end as DiagnosisSubChapter
	,p78.[Outpatient procedure tariff (£)] as OldOutPrice
	,p89.[Outpatient procedure tariff (£)] as NewOutPrice
	,(cast(nullif(nullif(replace(p89.[Outpatient procedure tariff (£)],',',''),'-'),0) as float)) - (cast(nullif(nullif(replace(p78.[Outpatient procedure tariff (£)],',',''),'-'),0) as float)) as OutIncrease
	,(((cast(nullif(nullif(replace(p89.[Outpatient procedure tariff (£)],',',''),'-'),0) as float)) - (cast(nullif(nullif(replace(p78.[Outpatient procedure tariff (£)],',',''),'-'),0) as float))) / (cast(nullif(nullif(replace(p78.[Outpatient procedure tariff (£)],',',''),'-'),0) as float))) * 100 as OutPercentChange
	
into outpatient_table
from [healthcare].[stage].[admitted1718] p78
left join [healthcare].[stage].[admitted1819] p89
on p78.[HRG code] = p89.[HRG code]


