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














