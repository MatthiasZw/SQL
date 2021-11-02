use standard
go

create schema verwaltung;
go
create schema einkauf;
go

alter schema verwaltung transfer lieferant;
go

alter schema verwaltung transfer artikel;
go

alter schema einkauf transfer verwaltung.lieferung;
go

use master
go

-- Logins erstellen

-- es k�nnen sich Windows Benutzer und Windows Gruppen mit SQL Server verbinden 
-- je nach Authentifizierungsmodus k�nnen Sich weiterhin auch Benutzer von  au�erhalb der Dom�ne verbinden

-- Windows Authentifizierung (Kerberus (�ber tcpip))
-- generiert ein selbstsigniertes Zertifikat wenn kein anderes Vorhanden ist 
-- Roten Arztkoffer verwenden (Konfigurationsmanager)
-- Firewall Ports m�ssen manuell ge�ffnet werden (so wenige wie m�glich)  
-- Server Browser ist wie dns f�r Weiterleitungen zust�ndig wenn mehrere Instanzen installiert sind

create login [sql16\genius] from windows;

create login [sql16\geschaeftsfuehrung] from windows with default_database=[master]; 


-- SQL Server Login erstellen

create login Frank with password = 'Pa$$w0rd';
create login Moni with password = 'Pa$$w0rd';
go 

--- Ausnahmen genereieren:

--- Bernd soll sich nie mit dem SQL- Server verbinden d�rfen

-- 1. Login f�r Bernd erstellen

create login [sql16\bernd] from windows;
go

-- 2. den Zugriff verweigern

deny connect sql to [sql16\bernd];
go

-- Serverrolle erstellen

create server role db_arbeit;
go

-- der serverrolle Berechtigungen zuweisen

grant create any database to db_arbeit;
go

GRANT VIEW ANY DATABASE TO [db_arbeit]

GO

GRANT ALTER ANY SERVER ROLE TO [db_arbeit]

GO

-- Das Login Genius der Serverrolle db_arbeit hinzuf�gen

alter server role db_arbeit add member [sql16\genius];
go

-- Einzelne Serverberechtigung f�r Genius zus�tzlich hinzuf�gen

grant alter any login  to [sql16\genius];  --- Anmeldeinformationen �ndern
go


-- Datenbankbenutzer einrichten
-- das bedeutet dass sich ein Login mit der 
-- Anweisung USE mit einer Datenbank verbinden kann

use standard
go 

create user genius for login [sql16\genius] with default_schema = verwaltung;


use [standard]
go
create user [gesch�ftsf�hrung] for login [sql16\gesch�ftsf�hrung]
go
use [standard]
go
alter user [gesch�ftsf�hrung] with default_schema=[verwaltung]
go


create user [produktion] for login [sql16\produktion]
go
use [standard]
go
alter user [gesch�ftsf�hrung] with default_schema=[lager]


create user [frank] for login [frank];
go
create user [moni] for login [moni];
go

-- Ausnahme f�r MAx

-- MAx soll sich nicht mit der Produktivdatenbank standard verbinden d�rfen 
-- weil er in der Ausbildung ist
-- ihm wird eine eigen Datenbank zugewiese wo er als dbo trainieren kann

--- 1. Zugriff auf standard verweigern

create user [max] for login [sql16\max];
deny connect to [max];

--- 2. �bungsdatenbank
create database azubi;
go

use azubi;

create user [max ] for login [sql16\max];
alter role db_owner add member [max];
go

use standard;
go

-- Gesch�ftsf�hrung soll select insert und update Berechtigungen auf die Tabellen
--lieferant und Artikel erhalten

-- Im Weiteren sollen sie lesend auf die Tabelle lieferung zugreifen
-- Tabellen LIeferat und Artikel befinden sich im Schema verwaltung

grant select, insert, update on schema::verwaltung to gesch�ftsf�hrung;  

grant select on schema::einkauf to gesch�ftsf�hrung;  

-- Die Mitarbeiter der Gruppe Produktion sollen select insert update und delete
-- auf die Tabelle Lieferung durchf�hren und select auf die Tabelle Lieferant


grant select, insert, update, delete on schema::einkauf to produktion;  

grant select on verwaltung.lieferant to produktion;  

-- Frank und Moni sollen mit select auf die Tabelle Lieferant und insert und 
--select auf die Tabelle Lieferung zugreifen


grant select on verwaltung.lieferant to moni;
grant select on verwaltung.lieferant to frank;

grant select, insert on einkauf.lieferung to moni;
grant select, insert on einkauf.lieferung to frank;
go



































