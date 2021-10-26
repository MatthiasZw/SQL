use standard
go

/*
Schreiben Sie ein Skript in dem Sie einer Variablen einen gültigen Tabellennamen der Datenbank standard übergeben.
Das Skript soll Ihnen die Anzahl der Datensätze der angegebenen Tabelle im Format 

Tabelle dbo.artikel, Anzahl Datensätze zurück geben.

*/

-- Empfehlung für schemaname.tabellenname
-- verwenden Sie die Kathalogsichten sys.tables und sys.schemas
--Wird ein falscher Tabellenname der Variablen übergeben, soll das Programm beendet werden



set nocount on;

declare @tab sysname, @tabvoll sysname, @anzahl int;
declare @sql varchar(max);
declare @erg table (anz int);

set @tab= 'lieferant';

----------------------------------------------------------------------- ermitteln des qualifizierten Tabellennamens

select @tabvoll = b.name + '.' + a.name from sys.tables as a join sys.schemas as b on a.schema_id = b.schema_id and a.name = @tab;

select @tabvoll;

----------------------------------------------------------------------- Überprüfen ob es die angegebene Tabelle gibt

if not exists (select * from sys.objects where object_id = object_id(@tabvoll) and type = 'U')
  begin
	raiserror('Die Tabelle existiert nicht', 10, 1);
	return;
  end;

-----------------------------------------------------------------------  Anzahl der Datensätze für die angegebene Tabelle ermitteln

set @sql = 'select count (*) from ' + @tabvoll;

insert into @erg execute(@sql);

select * from @erg;

select @anzahl = anz from @erg;

------------------------------------------------------------------------ Ergebnis ausgeben

print 'Tabelle ' + @tabvoll + ', Anzahl Datensätze = ' + cast(@anzahl as varchar(10)); 

set nocount off;
go
