use standard
go

declare @nr char(3), @namen varchar(100), @ort varchar(100)
set @ort = 'Hamburg';

declare lief_anz cursor for

select lnr, lname from lieferant where lstadt = @ort;

open  lief_anz;

fetch lief_anz into @nr, @namen;

while @@fetch_status  = 0

begin 

	print 'Der Lieferant ' + @namen + ' (' + @nr + ') wohnt in ' + @ort + '.';

	fetch lief_anz into @nr, @namen;
end;

deallocate lief_anz;
go

