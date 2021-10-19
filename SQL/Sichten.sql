use standard
go

--Sichten (VIEWS) Teilmengen aus Spalten und Zeilen

--- Die create view ...  Anweisung darf nicht mit anderen SQL-Anweisungen in einem Stapel stehen


create view hamb_lief 
as select lnr, lname, lstadt from lieferant
where lstadt = 'Hamburg';
go

-- eine Sicht wird verwendet wie eine Basistabelle
--- Die Sicht selbst ist als objekt in sys.objects oder sys.views abgespeichert


select * from sys.objects where object_id= object_id('hamb_lief');

-- die Abfrage der Sicht wird in der Kathalogsicht sys.sqlmodules gespeichert

select * from sys.sql_modules where object_id= object_id('hamb_lief');

exec sp_helptext 'hamb_lief';

go

--- Quelltext der Sicht verstecken

alter view hamb_lief 
with encryption
as select lnr, lname, lstadt from lieferant
where lstadt = 'Hamburg';
go

exec sp_helptext 'hamb_lief';

select * from sys.sql_modules where object_id= object_id('hamb_lief');   -----------> nicht mehr lesbar, null, verschlüsselt

go

create view lieflief
as
select a.lnr, lname, status, lstadt, anr, lmenge, ldatum from lieferant as a
join lieferung as b on a.lnr=b.lnr;
go

select * from lieflief;


---Datenänderungen über eine Sicht (Insert, Update, Delete)

/*
Datenänderungen über eine Sicht welche eine Abfrage über mehrere BAsistabellen
durchführt sind nur eingeschränkt oder überhaupt nicht möglich

Gelöst wird das Problem mit einem Instead OF trigger.

*/

-- Insert über die Sicht hamb_lief

insert into hamb_lief values('L30', 'Mucker', 'Hamburg');
go

select * from hamb_lief;
select * from lieferant;

---Problem beim insert

insert into hamb_lief values('L31', 'Rüsseltraktorist', 'Erfurt');
go

select * from hamb_lief;
go
--- Problem lösen

alter view hamb_lief 
as select lnr, lname, lstadt from lieferant
where lstadt = 'Hamburg'
with check option;
go

insert into hamb_lief values('L32', 'Warmduscher', 'Hamburg');
go


--- Update 

--- Der Lieferant mit der Lieferantennummer L32 hat seinen NAmen geändert 
--- und heißt jetzt Niedrigfunker

Update hamb_lief set  lname = 'Niedrigfunker' where lnr= 'L32';


--- Lieferant L32 will wieder zurück nach Tannroda

Update hamb_lief set  lstadt = 'Tannroda' where lnr= 'L32';    -- Geht nicht wegen with check option


--- Delete 

-- löscht alle datensätze in der Basistabelle die die Where-Klausel der Sicht erfüllen

--- delete hamb_lief; löscht alle Lieferanten aus Hamburg ---

delete hamb_lief where lnr > 'L05';

select * from hamb_lief;

select * from lieferant;

































