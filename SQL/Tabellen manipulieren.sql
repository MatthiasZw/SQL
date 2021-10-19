use standard
go

--- DML Anweisung Data Manipulation Language

--- dazu gehören die SQL Anweisungen
		--- insert into ...values  für Aufnehmen von datensätzen  bis 1024 werte
		--- delete					zum löschen
		--- update					ändern eines oder mehrerer Spaltenwerte eines oder mehrerer Datensätze

--- insert 
--in der Reihenfolge der Spalten

insert into lieferant values('L11', 'Kramer', 5, 'Halle');

--Spaltenreihenfolge ändern

insert into lieferant (lstadt, lname, lnr, status) values('Erfurt', 'Krause', 'L12', 5);

-- Unbekannte Werte aufnehmen

insert into lieferant values('L13', 'Maier', null, 'Jena');

---oder 

insert into lieferant(lnr, lname, status) values('L14', 'Schulze', 5);


--- default werte aufnehmen

alter table verwaltung.lieferant add constraint lstadt_def default 'Weimar' for lstadt;

insert into lieferant values('L15', 'Ullrich', 5, default);

-- oder 

insert into lieferant (lnr, lname, status) values('L16', 'Heinrich', 5);

select * from lieferant;

---------------------------------------------------------------------------------------------------------------------


create table artikel_rot
(anr char(3) not null, 
namen varchar(200),
text varchar(max) null);

drop table artikel_rot;

-- Insert into mit select abrfrage

insert into artikel_rot(anr, namen) select anr, aname from artikel where farbe = 'rot';

select * from artikel_rot;

--Insert mit der Funktion OPENROWSET() und der Option BULK   (Lädt Medien)

insert into artikel_rot values ('A10', 'Unterlegscheibe',
(select * from openrowset(bulk 'C:\Users\Student\Documents\Dateien\test.txt', single_blob) as a));

select * from artikel_rot;


--- DML Anweisungen mitschneiden

create table spion
(wann datetime not null,
wer sysname not null,
was varchar(50),
neuer_wert varchar(100) null, 
alter_wert varchar(100) null);

----Insert mit output

insert into lieferant output  GETDATE(), SUSER_NAME(), 'Insert', inserted.lnr, null into spion
values('L21', 'Kurzer', 5, 'Gotha');

select * from spion;


---Delete Anweisung

---Delete sollte nie ohne Where Klausel verwendet werden

delete lieferant 
output GETDATE(), SUSER_NAME(), 'Delete', null, deleted.lnr into spion
where lnr > 'L20';


select * from spion;

--- Alle Lieferanten mit einer Lieferantennummer größer L15 die nicht geliefert haben löschen

delete lieferant
output GETDATE(), SUSER_NAME(), 'Delete', null, deleted.lnr into spion
where lnr > 'L15' 
and lnr not in(select * from lieferung);


--- oder 

delete lieferant
output GETDATE(), SUSER_NAME(), 'Delete', null, deleted.lnr into spion
from lieferant as a left join lieferung as b on a.lnr = b.lnr
where a.lnr > 'L15'
and b.lnr is null;


select * from spion;
select * from lieferant;


---- UPDATE Anweisung --- 
update lieferant
set status = status + 10
output GETDATE(), SUSER_NAME(), 'Update', inserted.status, deleted.status into spion
where lnr > 'L05';

select * from spion;
select * from lieferant;

-- Erhöhen Sie den Statusweret der Lieferanten, die mindestens 3x geliefert haben um um 10 Punkte

update lieferant
set status = status + 10
output GETDATE(), SUSER_NAME(), 'Update', inserted.status, deleted.status into spion
where lnr  in (select distinct lnr from lieferung group by lnr having count(lnr) >= 3);













