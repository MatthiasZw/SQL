use master
go

--Außendienstler


create login Siggi with password = 'Pa$$w0rd';
create login Otto with password = 'Pa$$w0rd';
go



--AZUBI


create login [sql16\gunther] from windows;
go

use standard
go

deny connect to [sql16\gunther];
go

create user [gunther] for login [sql16\gunther];

create database testdb;
go

--Testanmeldungen für Azubi

use testdb;
go

create login test1 with password = 'Pa$$w0rd';
create login test2 with password = 'Pa$$w0rd';
go

alter role db_owner add member [gunther];
go

create user [test1] for login [test1];
go
create user [test2] for login [test2];
go


--- Alle Mitarbeiter können sich mit Standard verbinden
use standard
go

create server role db_standard;
go


grant create any database to db_standard;
go


use standard
go

create login [sql16\Leitung] from windows;

create user [Leitung] for login [sql16\Leitung];

alter server role db_standard add member [sql16\Leitung]  ;
go


create login [sql16\Einkauf] from windows;

create user [Einkauf] for login [sql16\Einkauf];

alter server role db_standard add member [sql16\Einkauf];
go


create login [sql16\Kundendienst] from windows;

create user [Kundendienst] for login [sql16\Kundendienst];

alter server role db_standard add member [sql16\Kundendienst];
go


--- Abteilung Leitung Standardschema

alter user [Leitung] with default_schema=[verwaltung]
go


--  Sonderrechte für Leitung

grant select, update, delete, insert on verwaltung.lieferant to Leitung;

grant select on einkauf.lieferung to Leitung;
grant select on verwaltung.artikel to Leitung;


--- Abteilung Kundendienst Standardschema und Sonderrechte

alter user [Kundendienst] with default_schema=[Einkauf]
go

grant select, update, insert on einkauf.lieferung to Kundendienst;



--- Abteilung Einkauf Standardschema

alter user [Einkauf] with default_schema=[verwaltung]
go


















