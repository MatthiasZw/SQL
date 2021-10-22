use master
go

---SQL Server Datenbanken

--- explizite Transaktionen

-- Von Ihrem Girokonto per HOMEBanking 5000 euro auf ihr Sparkonto 


begin transaction banane

T1:
update gitokonto 
set betrag = betrag -5000
where kontonummer = '0815';

T2:
update sparkonto 
set betrag = betrag + 5000
where kontonummer = '0817';

commit transaction banane

Checkpoint: zwangsausschreiben aller pufferseiten in die datanbankdateien alle 3? minuten

			nichtaktiver teil des protokolls am anfang abgeschnitten...


			recovery ---> rollback nicht vollständig comittetter transaktionen



1. Datei *.mdf
protokoll *.ldf 
2. dateien *.ndf


--create database firma;
go

--exec sp_helpdb firma;


-- datenbank standard erzeugen

--der systemkatalog der datenbank befindet sich auf e:\dbdaten
--Anfangsgröße 5 mb, endgröße 1 gb, erweiterungen schrittweise 2%

--Daten befinden sich in einer datei auf g:\daten
--Anfangsgröße 10 gb, endgröße 20 gb, erweiterungen schrittweise 500 mb

-- das protokoll befindet sich auf f:\dbprotokoll
--Anfangsgröße 2 gb, endgröße 10 gb, erweiterungen schrittweise 20%


create database standard
on primary (name= standard_kat,
			filename = 'e:\dbdaten\standard_kat.mdf',
			size = 5 MB,
			maxsize = 1 GB,
			filegrowth = 2 %),
filegroup passiv (name= standard_daten1,
			filename = 'h:\daten\standard_daten1.ndf',
			size = 10 GB,
			maxsize = 20 GB,
			filegrowth = 500 MB)
log on (name= standardlog,
			filename = 'f:\dbprotokoll\standardlog.ldf',
			size = 2 GB,
			maxsize = 10 GB,
			filegrowth = 20 %);

go

exec sp_helpdb standard;

-- Standarddateigruppe festlegen damit *.mdf intakt bleibt

alter database standard modify filegroup passiv default;

use standard
go

exec sp_helpfilegroup;

