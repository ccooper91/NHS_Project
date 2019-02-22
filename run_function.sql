use healthcare
go
declare @epitype nvarchar(200) = 'Combined day case / ordinary elective spell tariff'
declare @elec int = 1
declare @staydays int = 168
declare @reducshort int = 1
declare @Hcode varchar(10) = 'AA22C'




select stage.old_tariff_calc(@epitype, @elec, @staydays, @reducshort, @Hcode) as old_price
--select stage.new_tariff_calc(@epitype, @elec, @staydays, @reducshort, @Hcode) as new_price