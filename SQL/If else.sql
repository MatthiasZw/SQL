use standard;
go

-- Bedingungen mit if..... else

if datepart(yy, getdate()) > datepart(yy, '31.12.2021')
begin 
	select * into #lief2006 from lieferung;

	raiserror('Daten kopiert', 10, 1);
end
else 
	print 'Kopieren nicht erforderlich';
go

select * from #lief2006;

if not exists (select * from artikel where anr = 'A20')
print 'Artikel existiert nicht!';


