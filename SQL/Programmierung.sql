/*Stapelprogramme
Cursor
dynamische sql-anweisungen
gespeichterte Prozeduren
benutzerdefinierte Funktionen
Trigger*/---------------------> Programmierung in T-SQL


-- Ein Skript wird als Datei mit der Endung .sql gespeichert 
	-- im Management-Studio oder in der sql cmd ausgeführt
	-- besteht aus einem oder mehreren Stapelprogrammen
	-- Stapel werden durch go getrennt

use standard
go

-- Sprachkonstrukte von T-SQL
--Anweisungsblöcke

begin
	select lnr, lname from lieferant;
	select anr from artikel;
end;

-- Kommentare		
	-- Einzeilig
	/*mehrzeilig*/

-- Meldungen

-- PRINT generiert eine Meldung die vom Client ausgwertet werden kann.
-- kann nur Strings verarbeiten und zeigt diese im Register Meldungen an

--Schnittstellen:
--odbc
--Oledb object linking embedded data base
--dot.net, c# etc 


print 'heute ist montag der ' + convert(char(10), getdate(), 104);

--Meldungen schreiben auf dei das Datenbanksystem oder eine Anwendung reagieren kann   

-- Diese Meldungen arbeiten mit schweregraden 1-25 und können ins Windows-Anwendugsprotokoll schreiben 

-- Anweisung RAISERROR()

-- Systemfehlermeldungen und Benutzerdefinerte Fehlermeldungen generieren
-- DIe Systemfehlermeldungen sind in der Katalogsicht sys.messages gespeichert
-- Benutzerdefinierte Systemfehlermeldungen können mit der gespeicherten Prozedur sys.addmessage zur katalogsicht hinzugefügt werden

select * from sys.messages;

select * from sys.messages where language_id = 1031;


raiserror(49925, 22, 1) with log;

-- benutzerdefinierte Fehlermeldung erstellen

-- benutzerdef meldungen beginnen mit einer Fehlernummer > 50000

exec sp_addmessage 500000, 10, 'Can not get deletet.', us_english, null, 'replace';

raiserror(500000, 10, 1);

exec sp_addmessage 500000, 10, 'Kann nicht gelöscht werden', german, null, 'replace';

select * from sys.messages where message_id = 500000;

use standard
go

--Arbeit mit VAriablen

-- werden deklariert mit Präfix @
-- Variablenname kann 128 Zeichen enthalten
-- variablen können nur an Stelle von Ausdrücken verwendet werden und nicht als Objektnamen
--Arrays müssen mit Dotnet Sprachen erstellt werden und im Server bereitgestellt werden
-- Variablen sind nur in dem Stapel gültig in dem sie erstellt werden

--Deklaration

declare @nr char(3) = 'L01', @ort varchar(200), @name varchar(200);

declare @rezept xml;
declare @lieferung xml;

declare @tab table(nr char(3), namen varchar(200), ort varchar(200));

-- Wertzuweisung zu Variablen

set @nr = 'L02';
select @name = lname, @ort = lstadt from lieferant where lnr = @nr;

set @rezept = '<kuchen>
				<mehl>200</mehl>
				<eier>6</eier>
				<zucker>150</zucker>
				</kuchen>';

set @lieferung = (select lieferant.lnr, lname, aname, ldatum from lieferant join lieferung on 
	lieferant.lnr = lieferung.lnr
	join artikel on lieferung.anr = artikel.anr
	for xml auto, root('Lieferung'),elements); 

insert into @tab select anr, aname, astadt from artikel;

print 'Der Lieferant' + @nem










