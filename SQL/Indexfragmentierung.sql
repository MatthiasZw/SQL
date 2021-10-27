use standard
go

/* Einer Variablen wird ein Tabellenname übergeben.
Der Tabellenname soll in einen qualifizierten Tabellennamen umgewandelt werden.
Danach sollen alle Indizes dieser Tabelle gesucht werden und für jeden gefundenen Index soll überprüft werden
ob eine Fragmentierung vorliegt und entsprechend darauf reagiert werden. Bei einer Frag. von 0-5% passiert nichts, bei 
6-30% wird neu organisiert und bei über 30% wird index neu erstellt.
Für jeden Index soll eine Statusmeldung ausgegeben werden, in der Form: 
Index <Indexname> ist stark fragmentiert, er wurde neu gebildet. */

declare @tabname sysname, @tabname_voll sysname, @indid int, @indname sysname;
set @tabname='lieferung';

--Gibt es die Tabelle?
if not exists (select * from sys.objects where name= @tabname)
begin
raiserror('Die Tabelle gibt es nicht in der Datenbank', 10, 1, @tabname);
return;
end;

--vollqualifizierten Namen bilden

select @tabname_voll = a.name + '.' + b.name from sys.schemas as a join sys.tables as b on a.schema_id = b.schema_id 
where b.name not like 'sys%' and b.name = @tabname;

declare tabind cursor for 
select index_id, name from sys.indexes where object_id = object_id(@tabname_voll);

open tabind;
fetch tabind into @indid, @indname;
while @@FETCH_STATUS = 0
	begin
		if (select avg_fragmentation_in_percent from sys.dm_db_index_physical_stats(db_id(), object_id(@tabname_voll),@indid, null, null)) <5
		begin 
			raiserror('Index %s nicht fragmentiert.', 10, 1, @indname);
		end;

		if (select avg_fragmentation_in_percent from sys.dm_db_index_physical_stats(db_id(), object_id(@tabname_voll),@indid, null, null)) between 5 and 30
		begin 
			exec ('alter index ' + @indname + 'on ' + @tabname_voll + ' reorganize;' )	
			raiserror('Index %s ist leicht fragmentiert. Er wurde reorganisiert', 10, 1, @indname);
		end;

		if (select avg_fragmentation_in_percent from sys.dm_db_index_physical_stats(db_id(), object_id(@tabname_voll),@indid, null, null)) > 30
		begin 
			exec ('alter index ' + @indname + 'on ' + @tabname_voll + ' rebuild;' )	
			raiserror('Index %s ist leicht fragmentiert. Er wurde reorganisiert', 10, 1, @indname);
		end;

	fetch tabind into @indid, @indname;
end;
deallocate tabind;
go



