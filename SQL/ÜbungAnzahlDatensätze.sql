use standard
go

/*
Schreiben Sie ein Skript in dem Sie einer Variablen einen g�ltigen Tabellennamen der Datenbank standard �bergeben.
Das Skript soll Ihnen die Anzahl der Datens�tze der angegebenen Tabelle im Format 

Tabelle dbo.artikel, Anzahl Datens�tze zur�ck geben.

*/

-- Empfehlung f�r schemaname.tabellenname
-- verwenden Sie die Kathalogsichten sys.tables und sys.schemas
--Wird ein falscher Tabellenname der Variablen �bergeben, soll das Programm beendet werden



set nocount on;

declare @tab sysname, @tabvoll sysname, @anzahl int;
declare @sql varchar(max);
declare @erg table (anz int);

set @tab= 'lieferant';

----------------------------------------------------------------------- ermitteln des qualifizierten Tabellennamens

select @tabvoll = b.name + '.' + a.name from sys.tables as a join sys.schemas as b on a.schema_id = b.schema_id and a.name = @tab;

select @tabvoll;

----------------------------------------------------------------------- �berpr�fen ob es die angegebene Tabelle gibt

if not exists (select * from sys.objects where object_id = object_id(@tabvoll) and type = 'U')
  begin
	raiserror('Die Tabelle existiert nicht', 10, 1);
	return;
  end;

-----------------------------------------------------------------------  Anzahl der Datens�tze f�r die angegebene Tabelle ermitteln

set @sql = 'select count (*) from ' + @tabvoll;

insert into @erg execute(@sql);

select * from @erg;

select @anzahl = anz from @erg;

------------------------------------------------------------------------ Ergebnis ausgeben

print 'Tabelle ' + @tabvoll + ', Anzahl Datens�tze = ' + cast(@anzahl as varchar(10)); 

set nocount off;
go
