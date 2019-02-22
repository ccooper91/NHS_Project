if object_ID('stage.overacrching_new_func') is not null
	begin
		drop function stage.overacrching_new_func
	end
go

create function stage.overacrching_new_func(@admiage int, @epistart varchar(20), @epiend varchar(20),
	@admimeth varchar(10), @Hcode varchar(10))

/*************************************************************************************************
Function to find the old tariff, and new tariff of a medical procedure from the NHS price 
tariff documents.
Requires following inputs:
@admiage - Patient age at admission as int
@epistart - episode start date as text in form 'yyyy-mm-dd'
@epiend - episode end date as text in form 'yyyy-mm-dd'
@admimeth - method of admission as defined in NHS HES dictionary as text
@Hcode - HRG code as text e.g. 'AA22C'

Gives following outputs:
@OldPrice - Calculation of 2017/2018 Tariff based on inputs (in £)
@NewPrice - Calculation of 2018/2019 Tariff based on inputs (in £)
@PriceChange - Change in price (in £)

Requires tables:
stage.admitted1718
stage.admitted1819

Example script to run function:
select stage.overacrching_new_func(@admiage, @epistart, @epiend, @admimeth, @Hcode)

****************************************************************************************************/

returns int
as
begin
declare @new int


/* Calculate staydays as number of days between epistart and epiend (data is input as text as in the HES data)*/
declare @staydays int
set @staydays = datediff(day,cast(@epistart as date), cast(@epiend as date))


/* Determine if incident is elective(1) or non-elective(0) based on admissions method (@admimeth - proc input)*/
declare @elec int
if (@admimeth like ('11')) set @elec = 1
else if (@admimeth like ('12')) set @elec = 1
else if (@admimeth like ('13')) set @elec = 1
else set @elec = 0


/* Determine whether or not patient qualifies for reduced stay emergency tariff, either 1 (yes) or 0 (no) */
declare @reducshort int
if (@admiage > 19 and @elec = 0) set @reducshort = 1
else set @reducshort = 0


/* Input values into functions to find old and new price tariffs */
select @new = stage.new_tariff_calc(@elec, @staydays, @reducshort, @Hcode)

return @new
end

