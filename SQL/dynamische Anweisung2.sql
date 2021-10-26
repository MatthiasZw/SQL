use standard
go

-- Indexfragmentierungsgrad abfragen für den PRimärschlüssel der Tabelle lieferant
-- Wenn er unter 30% ist soll der Index reorganisiert werden

declare @tab sysname, @indid int
set @tab = 'lieferant';
set @indid = 1;

declare @sql varchar(max);

if (select avg_fragmentation_in_percent from sys.dm_db_index_physical_stats(db_id(),object_id(@tab),@indid,null,null)) <= 30
	begin
	set @sql='alter index lnr_pk on ' + @tab + ' reorganize';
	--select @sql;
--	execute('alter index lnr_pk on ' + @tab + ' reorganize');
	execute(@sql);
	raiserror('Der Index wurde reorganisiert.', 10, 1);
	end;
go
