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











