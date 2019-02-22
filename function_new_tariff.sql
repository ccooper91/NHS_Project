if object_ID('stage.new_tariff_calc') is not null
	begin
		drop function stage.new_tariff_calc
	end
go
create function stage.new_tariff_calc(@elec int, @staydays int, @reducshort int, @Hcode varchar(10))

/************************************************************************************************************
stage.old_tariff_calc 
This function calculates the final cost (in £) for a hospital treatment based on the patient input parameters
using the price list from 2017/2018. 
It requires the following input parameters:
@elec [1 or 0] - Whether the episode was elective or not
@staydays - Number of days in episode
@reducshort [1 or 0] - Whether patient is eligible for a reduced stay tariff
@Hcode - Patient HRG code

Gives output:
@OldPrice - Calculation of 2017/2018 Tariff based on inputs (in £)

Requires table:
stage.admitted1819

Example data input:
@elec = 1
@staydays = 168
@reducshort = 1
@Hcode = 'AA22C'

Example script to run function:
select stage.old_tariff_calc(@epitype, @elec, @staydays, @reducshort, @Hcode)
*************************************************************************************************************/

returns int
as
begin
declare @new_tariff int


/* EXAMPLE INPUTS FOR DEBUGGING/TESTING *********/
--declare @elec int = 1
--declare @staydays int = 168
--declare @reducshort int = 1
--declare @Hcode varchar(10) = 'AA22C'
/*********** END TEST PARAMETERS */

;with cte
as
(
select
	/* Find basic tariff based on @epitype parameter */
	case
		when @elec = 1 and (nullif(replace([Combined day case / ordinary elective spell tariff (£)],',',''),'-')) is not null then (nullif(replace([Combined day case / ordinary elective spell tariff (£)],',',''),'-'))
		when @elec = 1 and (nullif(replace([Combined day case / ordinary elective spell tariff (£)],',',''),'-')) is null then ((replace([Day case spell tariff (£)],',','')) + (replace([Ordinary elective spell tariff (£)],',','')))
		when @elec = 0 then (nullif(replace([Non-elective spell tariff (£)],',',''),'-'))
	else 0
	end as DayTariff

	/* If applicable add column to calculate charge for long stay based on charge per day for number of days over trim point */
	,case
		when @elec = 1 and @staydays > cast([Ordinary elective long stay trim point (days)] as int) then (@staydays - cast([Ordinary elective long stay trim point (days)] as int)) * [Per day long stay payment (for days exceeding trim point) (£)]
		when @elec = 0 and @staydays > cast([Non-elective long stay trim point (days)] as int) then (@staydays - cast([Non-elective long stay trim point (days)] as int)) * [Per day long stay payment (for days exceeding trim point) (£)]
	end as LongStayCharge

	/* If applicable add column for Reduced Short Stay Tariff */
	,case
		when @reducshort = 1 and @staydays > 2 then 0- (nullif(replace([Reduced short stay emergency tariff (£)],',',''),'-'))
		else 0
	end as ReductionTariff
	,[HRG code]

from stage.admitted1819
)

/* Add values from all columns from CTE above to get final tariff cost */
select 
	@new_tariff = isnull(DayTariff,0) + isnull(LongStayCharge,0) + isnull(ReductionTariff,0)
	from cte
where [HRG code] = @Hcode


return @new_tariff
end

