
/************************************ Part 3 of Project ***********************************/
/*  Script to run overarching functions to calculate tariffs for multiple rows in a table */
/* Stored proc was transfored into two separate functions to make this possible */
/******************************************************************************************
Finds the old tariff, new tariff and price difference of a medical procedure from the NHS 
price tariff documents and displays in 3 new columns alongside HES data.
*******************************************************************************************/

select
	HRG_code
	,admiage
	,epistart
	,epiend
	,admimeth
	,stage.overacrching_old_func([admiage], [epistart], [epiend], [admimeth], [HRG_code]) as [Old Tariff]
	,stage.overacrching_new_func([admiage], [epistart], [epiend], [admimeth], [HRG_code]) as [New Tariff]
	,(stage.overacrching_new_func([admiage], [epistart], [epiend], [admimeth], [HRG_code]) - stage.overacrching_old_func([admiage], [epistart], [epiend], [admimeth], [HRG_code])) as [Price Change]
from stage.HES_with_HRG

