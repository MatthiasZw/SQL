use standard;
go

-- Select ohne FROM

select getdate();

select 5*12;
select 5/2;

select 5/2.5;

select 'abc';

--- Select mit Objekteingabe



select * from verwaltung.lieferant;
select * from verwaltung.lieferant;

select lnr, lname, status, lstadt from verwaltung.lieferant;


select lnr, lname, status, lstadt from  sql16serv1.standard.verwaltung.lieferant;

/*Zaubern

Hilfsmittel erstellen um bei Abfragen den Schemanamen nicht benutzen zu müssen.
Wir erstellen uns Synonyme:
*/

create synonym lieferant for standard.verwaltung.lieferant;
go
create synonym artikel for standard.verwaltung.artikel;
go
create synonym lieferung for standard.einkauf.lieferung;
go

select * from lieferant;

-- Where Klausel

-- Vergleichsoperatoren

-- alle roten artikel

select * from artikel where farbe='rot';

-- Alle Lieferungen mit einer LIefermenge von mindestens 200 Stück


--Alle Lieferungen vom 9.8.1990

select * from lieferung where ldatum='09-08-1990';

--Bereiche

-- Alle Lieferungen zwischen dem 01.08.1990 und dem 31.08.1990

select * from lieferung where ldatum between '01.08.1990' and '31.08.1990'; 

-- Alle Lieferanten deren Namen mit dem Buchstaben B -J beinnen

select * from lieferant where lname between 'B' and 'Jz';   --- unerwartetes Ergebnis

-- IN Operator

-- Gesucht sind die roten, grünen und schwarzen Artikel

select * from artikel where farbe in ('rot', 'schwarz', 'grün');

select * from artikel where farbe='rot' or farbe='schwarz' or farbe='grün';

-- Gesucht sind die unroten, ungrünen und unschwarzen artikel

select * from artikel where farbe not in('rot','grün','schwarz');

select * from artikel where farbe <>'rot' and farbe<>'schwarz' and farbe <>'grün';

-- Lieferungen die nicht zwischen dem 01.08.1990 und dem 31.08.1990 stattgefunden haben 

select * from lieferung where ldatum not between '01.08.1990' and '31.08.1990';

-- Zeichenfolgenvergleich
-- ist nur auf Spalten vom datentyp alphanum möglich
-- Schlüsselwort LIKE oder NOT LIKE

-- Alle Artikel deren Namen mit einem S beginnt

select * from artikel where aname like'S%';

-- Alle artiekl deren Namen an zweiter Stelle ein o vorkommt;

select * from artikel where aname like '_o%';

-- Alle artiekl deren Namen an vorletzter Stelle ein l vorkommt;

select * from artikel where aname like '%l_';

--Alle Liferanten deren Namen mit b - J beginnen

select * from lieferant where lname like '[B-J]%';

--Alle Liferanten deren Namen mit b oder J beginnen

select * from lieferant where lname like '[BJ]%';

--Gesucht sind die Lieferanten in deren Namen kein A vorkommt

select * from lieferant where lname not like '%a%';	

insert into lieferant values ('L06', 'Schu%ze',10, 'Erfurt');
insert into lieferant values ('L07', 'Müller',null, null);

select * from lieferant

-- gesucht sind die lieferanten in deren Namen ein Prozentzeichen vorkommt

select * from lieferant where lname like '%%%'; -- Falsch

-- Platzhalter maskieren

select * from lieferant where lname like '%z%%' escape 'z';


--arbeiten mit unbekannten werten
-- welche lieferanten haben einen unbekannten wohnort

select * from lieferant where lstadt is null;

-------------------------------------------------------------------

-- mehrere Suchbedingungen in der Where Klausel

select * from artikel where gewicht > 15 and astadt like '[E-L]%' or amenge > 700;

select * from artikel where gewicht > 15 and (astadt like '[E-L]%' or amenge > 700);

select * from lieferung where ldatum in ('5.8.1990', '6.8.1990');
select * from lieferung where ldatum between '5.8.1990' and  '6.8.1990';
select * from lieferung where ldatum >= '5.8.1990' and ldatum  <= '6.8.1990';

select aname, anr from artikel where (farbe in('rot', 'blau') and astadt = 'hamburg') or ((amenge between 900 and 1500) and aname like '%a%');

select * from lieferant where lname like '[A-G]%';

select * from lieferant where lname like '[SCB]_a%' and lstadt  not like '%ried%' ;

select * from artikel where gewicht = 0 or gewicht is null;

insert into lieferant values('L10', 'Brandt', 10, 'Riedmannshausen');
insert into lieferant values('L11', 'Sharon', 10, 'Mittelriedstadt');
insert into lieferant values('L12', 'Chan', 10, 'Teufelsried');




