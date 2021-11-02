use standard;
go


create procedure indexfrag @tabname sysname, @indname sysname = null
as

declare  @tabname_voll sysname, @indid int;

--Gibt es die Tabelle?
if not exists (select * from sys.objects where name= @tabname)
begin
raiserror('Die Tabelle gibt es nicht in der Datenbank', 10, 1, @tabname);
return;
end;


-- vollqualifizierten Namen bilden
select @tabname_voll = a.name + '.' + b.name from sys.schemas as a join sys.tables as b on a.schema_id = b.schema_id 
where b.name not like 'sys%' and b.name = @tabname;

-- Wenn kein Indexname angegeben wird:
if @indname is null
	begin
		declare tabind cursor for 
		select index_id, name from sys.indexes where object_id = object_id(@tabname_voll);
		
		open tabind;
		fetch tabind into @indid, @indname;
		while @@FETCH_STATUS = 0
			begin
				if (select avg_fragmentation_in_percent from sys.dm_db_index_physical_stats(db_id(), object_id(@tabname_voll),@indid, null, null)) <5
				begin 
					raiserror('Index %s nicht fragmentiert (unter 8 Prozent), alles ok, nichts unternommen.', 10, 1, @indname);
				end;

				if (select avg_fragmentation_in_percent from sys.dm_db_index_physical_stats(db_id(), object_id(@tabname_voll),@indid, null, null)) between 5 and 30
				begin 
					exec ('alter index ' + @indname + 'on ' + @tabname_voll + ' reorganize;' )	
					raiserror('Index %s ist leicht fragmentiert (8-30 Prozent). Er wurde reorganisiert', 10, 1, @indname);
				end;

				if (select avg_fragmentation_in_percent from sys.dm_db_index_physical_stats(db_id(), object_id(@tabname_voll),@indid, null, null)) > 30
				begin 
					exec ('alter index ' + @indname + 'on ' + @tabname_voll + ' rebuild;' )	
					raiserror('Index %s ist fragmentiert (über 30 Prozent). Er neu gebildet', 10, 1, @indname);
				end;

			fetch tabind into @indid, @indname;
		end;
		deallocate tabind;
	end;

-- Wenn ein Indexname angegeben wird:
if @indname is not null

	begin 
		declare tabind2 cursor for 
		select index_id, name from sys.indexes where object_id = object_id(@tabname_voll) and name = @indname;

		open tabind2;
		fetch tabind2 into @indid, @indname;
		while @@FETCH_STATUS = 0
			begin
				if (select avg_fragmentation_in_percent from sys.dm_db_index_physical_stats(db_id(), object_id(@tabname_voll),@indid, null, null)) <8
				begin 
					raiserror('Index %s nicht fragmentiert (unter 8 Prozent), alles ok, nichts unternommen.', 10, 1, @indname);
				end;

				if (select avg_fragmentation_in_percent from sys.dm_db_index_physical_stats(db_id(), object_id(@tabname_voll),@indid, null, null)) between 8 and 30
				begin 
					exec ('alter index ' + @indname + 'on ' + @tabname_voll + ' reorganize;' )	
					raiserror('Index %s ist leicht fragmentiert (8-30 Prozent). Er wurde reorganisiert', 10, 1, @indname);
				end;

				if (select avg_fragmentation_in_percent from sys.dm_db_index_physical_stats(db_id(), object_id(@tabname_voll),@indid, null, null)) > 30
				begin 
					exec ('alter index ' + @indname + 'on ' + @tabname_voll + ' rebuild;' )	
					raiserror('Index %s ist fragmentiert (über 30 Prozent). Er wurde gebildet', 10, 1, @indname);
				end;

			fetch tabind2 into @indid, @indname;
		end;
		deallocate tabind2;

	end;

go

exec indexfrag 'lieferung', 'lief_pk';