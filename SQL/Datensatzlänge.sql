use standard
go

-- Gleiches Problem, nur jetzt nicht die Anzahl der Datens�tze sondern die L�nge des Datensatzes der angegebenen Tabelle

set nocount on;

declare @tab sysname, @tabvoll sysname, @anzahl int;
declare @sql varchar(max);
declare @erg int;

set @tab= 'lieferant';----------------------------------------------------------------------- ermitteln des qualifizierten Tabellennamens

select @tabvoll = b.name + '.' + a.name from sys.tables as a join sys.schemas as b on a.schema_id = b.schema_id and a.name = @tab;

select @tabvoll;

----------------------------------------------------------------------- �berpr�fen ob es die angegebene Tabelle gibt

if not exists (select * from sys.objects where object_id = object_id(@tabvoll) and type = 'U')
  begin
	raiserror('Die Tabelle existiert nicht', 10, 1);
	return;
  end;
  
-----------------------------------------------------------------------  L�nge des Datensatzes f�r die angegebene Tabelle ermitteln
select @erg = sum(max_length) from sys.all_columns where object_id = object_id(@tabvoll);

------------------------------------------------------------------------ Ergebnis ausgeben

print 'Tabelle ' + @tabvoll + ', L�nge Datens�tze = ' + cast(@erg as varchar(10)); 

set nocount off;
go

