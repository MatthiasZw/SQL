use standard
go

-- Where Bedingungen in dynamischen Anweisungen

declare @tab sysname, @sp1 sysname, @sp2 sysname, @sp3 sysname , @wert varchar(50);
declare @sql varchar(max);
declare @hk char(1)= char(39);

set @tab= 'artikel';
set @sp1= 'aname';
set @sp2= 'farbe';
set @sp3='astadt';
set @wert= 'Hamburg';

set @sql = 'select ' + @sp1 + ', ' + @sp2 + ' from ' + @tab + ' where ' + @sp3 + ' = ' + @hk + @wert + @hk;

exec (@sql);


