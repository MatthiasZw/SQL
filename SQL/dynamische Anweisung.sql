use standard;
go

declare @objekt sysname = 'lieferant'

if not exists (select * from sys.objects where OBJECT_ID = OBJECT_ID(@objekt))
	begin
		print ' Tabelle existiert nicht.';
		return;
	end; 

----------

--select * from @objekt;   <--dynamische Anweisung gebraucht

execute('select * from ' + @objekt);

go