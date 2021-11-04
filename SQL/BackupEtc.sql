use standard
go

exec sp_spaceused;
go

use master
go

-- Neues Sicherungsmedium

exec sp_addumpdevice 'disk', 'msdb_sicher',  'g:\dbbackup\msdb_sicher.bak';
go

-- Eine Datenbank in eine BAckupdatei sichern:

backup database firma 
to disk = 'g:\dbbackup\firma_sicher.bak'
with name = 'Firma_Voll';


--- Die Masterdatenbank und die msdb Datenbank mit dem SQLSMS sichern.



-- Szenario Datenbank Standard mit vollst�ndiger, differntieller und Protokoll-Sicherung

-- 1. vollst�ndiger Sicherung

backup database standard
to standard_sicher with name = 'vollst�ndig';

-------------------------------------------
use standard
insert into verwaltung.lieferant values ('L20', 'Teufel', 5, 'Erfurt');

--- sichern des Protokolls

backup log standard 
to standard_sicher with name = 'protokoll';

-----------------------------------------------------

insert into einkauf.lieferung values ('L20', 'A08', 500, getdate());

-----------------------------------


--- sichern des Protokolls

backup log standard 
to standard_sicher with name = 'protokoll';

insert into verwaltung.artikel values ('A11', 'scheibe', 'blau', 80, 'Jena', 100);

-- differntielle Sicherung

backup database standard to standard_sicher with name = 'differentiell', differential;
go
------------------------------------------------------------------------------------

-- Sicherung �berpr�fen

-- 1. Medienheader �berpr�fen ob er intakt ist

restore verifyonly from standard_sicher;

-- 2. Anzeigen aller Datenbankdateien und Protokolldateien der gesicherten Datenbank

restore filelistonly from standard_sicher;

-- 3. Informationen �ber das angegebene Sicherungsmedium 

restore labelonly from standard_sicher;

--- 4. Anzeigen der Sicherungss�tze im Sicherungsmedium 

restore headeronly from standard_sicher;

insert into verwaltung.lieferant values ('L22', 'Kupfer', 10, 'Tannroda');


--- Jetzt stellen wir fest, dass ein Device mit Daten defekt ist, 
-- Die Gesch�ftsregeln besagen dass so wenig Datenverlust wie m�glich (gar keiner) stattfinden soll

-- Wir sichern jetzt das protokollfragmenet und �berf�hren die Datenbank standard in den Wiederherstellungsmodus

use master

backup log standard to standard_sicher with name='fragment', norecovery;

-- Datenbanken aus einer Sicherung Wiederherstellen

-- Alle Datenbanken au�er Master und tempdb werden auf die gleiche Weise wiederhergestellt
-- tempdb kann nicht wiederhergestellt werden und  master wird von au�en wiederhergestellt


-- Wiederherstellung erfolgt mit dem Objekt-Explorer oder, viel besser, mit "restore..." weil msdb nicht immer in Ordnung sein muss

restore headeronly from standard_sicher;
go

restore database standard from standard_sicher with file = 1, norecovery;
restore database standard from standard_sicher with file = 9, norecovery;

restore log standard from standard_sicher with file = 10, norecovery;
go
restore log standard from standard_sicher with file = 11, norecovery;
go
restore log standard from standard_sicher with file = 12, norecovery;
go
restore log standard from standard_sicher with file = 13, recovery;


use standard
go
select * from verwaltung.lieferant;



-- Wiederherstellen der Systemdatenbanken Master und msdb

-- erst sichern

backup database master to master_sicher with name = 'vollstaendig', format;

backup database msdb to msdb_sicher with name = 'vollstaendig', format;


restore headeronly from master_sicher;
go

restore headeronly from msdb_sicher;
go


-- 

























