use standard
go 


--Tabellen

create table lieferant
(lnr char(3) not null,
lname varchar(200) not null,
status tinyint null,
lstadt varchar(500) null);
go

create table artikel
(anr char(3) not null,
aname nvarchar(200) not null,
farbe char(10) null,
gewicht smallint null,
astadt varchar(500) not null,
amenge int not null);
go

create table lieferung
(lnr char(3) not null,
anr char(3) not null,
lmenge int not null,
ldatum date not null);
go

exec sp_help lieferant;

insert into lieferant values('L01', 'Schmidt', 20, 'Hamburg');

select * from lieferant;

insert into lieferant values
('L02', 'Jonas', 10, 'Ludwigshafen'),
('L03', 'Blank', 30, 'Ludwigshafen'), 
('L04', 'Clark', 20, 'Hamburg'), 
('L05', 'Adam', 30, 'Aachen');
go

insert into Artikel values
('A01', 'Mutter', 'rot', 12, 'Hamburg', 800),
('A02', 'Bolzen', 'grün', 17, 'Ludwigshafen', 1200), 
('A03', 'Schraube', 'blau', 17, 'Mannheim', 400), 
('A04', 'Schraube', 'rot', 14, 'Hamburg', 900),
('A05', 'Nockenwelle', 'blau', 12, 'Ludwigshafen', 1300), 
('A06', 'Zahnrad', 'rot', 19, 'Hamburg', 500);
go

insert into Lieferung values
('L01', 'A01', 300, '18.05.90'),
('L01', 'A02', 200, '13.07.90'),
('L01', 'A03', 400, '01.01.90'),
('L01', 'A04', 200, '25.07.90'),
('L01', 'A05', 100, '01.08.90'),
('L01', 'A06', 100, '23.07.90'),
('L02', 'A01', 300, '02.08.90'),
('L02', 'A02', 400, '05.08.90'),
('L03', 'A02', 200, '06.08.90'),
('L04', 'A02', 200, '09.08.90'),
('L04', 'A04', 300, '20.08.90'),
('L04', 'A05', 400, '21.08.90');

go

select * from lieferung;

go

---Einschränkungen für Tabellen

-- Datentyp einer Spalte ändern

exec sp_help artikel;

-- Spalte aname der Tabelle Artikel von nvarchar in varchar ändern

alter table artikel alter column aname varchar(200);

-- Einschränkungen für Tabellen

--Primärschlüssel

alter table lieferant add constraint lnr_pk primary key(lnr);
go

alter table artikel add constraint anr_pk primary key(anr);
go

alter table lieferung add constraint lief_pk primary key(lnr, anr, ldatum);
go

	---doppelte datensätze löschen:
	-select distinct * into #zitrone from lieferant;
	-delete lieferant;
	-insert into lieferant select * from #zitrone;
	- drop table #zitrone;


--- Einschränkung Unique

alter table lieferant add vers_nr varchar(15) null;

update lieferant set vers_nr = 'ABC-99-66-WERT' where lnr = 'L01';
update lieferant set vers_nr = 'ABC-00-66-WERT' where lnr = 'L02';
update lieferant set vers_nr = 'ABC-11-66-WERT' where lnr = 'L03';
update lieferant set vers_nr = 'ABC-22-66-WERT' where lnr = 'L04';
update lieferant set vers_nr = 'ABC-33-66-WERT' where lnr = 'L05';

select * from lieferant;
go

alter table lieferant add constraint vers_nr_unq unique(vers_nr);

insert into lieferant values('L06', 'Hustensaftschmuggler', 5, 'Leipzig', 'ABC-44-66-WERT');
go

-- Default Einschränkung
-- Einer Spalte einen Standardwert zuordnen

--Standardwert zuweisen

--Die Spalte Lstadt soll den Standarwert 'Erfurt' erhalten.

alter table lieferant add constraint lstadt_def default 'Erfurt' for lstadt;

--Test:

insert into lieferant values ('L07', 'Warmduscher', 5, Default, 'Wertzu-99-hh');

select * from lieferant;

--- ChECK Einschränkung
--- festlegen welche daten für eine Tabelle möglich sind

--- Alle Lieferantennamen müssen mit einem BUchstaben von A-Z beginnen

alter table lieferant add constraint lname_chk check(lname like '[a-z]%');

-- der Status muss zwischen 0 und 100 (einschließlich) liegen

alter table lieferant add constraint status_chk check(status between 0 and 100); --- tinyint beginnt eh bei 0

-- Fremdschlüssel

-- alle Nichtnullwerte einer Fremdschlüsselspalte müssen Werte in einer referenzierten Primärschlüsselspalte sein

alter table lieferung add constraint lnr_fk foreign key(lnr) references lieferant(lnr);

alter table lieferung add constraint anr_fk foreign key(anr) references artikel(anr);

-- Test

insert into lieferung values ('L03', 'A06' ,500, '12.12.1990' );

select * from lieferung;

exec sp_help lieferant;














