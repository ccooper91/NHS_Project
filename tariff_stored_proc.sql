if object_ID('tariff_finder_proc') is not null
	begin
		drop proc tariff_finder_proc
	end
go

create proc tariff_finder_proc
/*************************************************************************************************
Stored procedure to find the old tariff, new tariff and price difference of a medical procedure 
from the NHS price tariff documents.
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

Example data input:
@epistart = '2009-07-06'
@episend = '2009-08-24'
@admimeth = '12'
@Hcode = 'AA22C'

Example script to run stored procedure:
declare @OldPrice int
declare @NewPrice int
declare @PriceChange int
exec tariff_finder_proc 21,'2009-07-06', '2009-08-24','12','AA22C', @OldPrice output, 
	@Newprice output, @Pricechange output

****************************************************************************************************/

/*Set input variables and types */
@admiage int --Patient age at admission
,@epistart varchar(20) -- episode start date as text in form 'yyyy-mm-dd'
,@epiend varchar(20) --episode end date as text in form 'yyyy-mm-dd'
,@admimeth varchar(10) -- method of admission as defined in NHS HES dictionary as text
,@Hcode varchar(10) --HRG code as text e.g. 'AA22C'

/* Set output variables and types */
,@OldPrice int output --Calculation of 2017/2018 Tariff based on inputs (in £)
,@NewPrice int output --Calculation of 2018/2019 Tariff based on inputs (in £)
,@PriceChange int output --Change in price (in £)
as


begin try
begin tran

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
select stage.old_tariff_calc(@elec, @staydays, @reducshort, @Hcode)
select stage.new_tariff_calc(@elec, @staydays, @reducshort, @Hcode)


/* Calculate change in price for @pricechange output from stored proc*/
set @pricechange = @NewPrice - @OldPrice

commit tran
end try

begin catch
print 'Procedure failed, transaction rolled back, check input parameters and try again'
rollback tran
end catch


/**********************************************************************************************/
/******************************* SCRIPT TO RUN STORED PROCEDURE *******************************/
go
declare @OldPrice int
declare @NewPrice int
declare @PriceChange int
exec tariff_finder_proc 21,'2009-07-06', '2009-08-24','12','AA22C', @OldPrice output, 
	@Newprice output, @Pricechange output

