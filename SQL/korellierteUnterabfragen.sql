use standard
go


----- korellierte UnterAbfragen

-- mit exists

-- Gesucht sind alle Angbaben zu Lieferanten die geliefert haben


select * from lieferant where exists(select * from lieferung where lieferant.lnr = lieferung.lnr);


-- mit Vergleichsoperatoren

-- Alle Angaben der Lieferanten die mehr als zweimal geliefert haben

select * 
	from lieferant
	where 2 < (select count(*)
				from lieferung
				where lieferant.lnr = lieferung.lnr);

	-- mit Alias

select * 
	from lieferant as a
	where 2 < (select count(*)
				from lieferung as b
				where a.lnr = b.lnr);

-- Unterabfragen in der SELECT - Liste

select anr, aname, gewicht, gewicht -(select avg(gewicht) from artikel) as [Differenz zum Durchschnittsgewicht] from artikel;


-- Unterabfragen in der FROM - Klausel
	-- siehe Thema JOIN


-- Verknüpfung von Tabellen mit JOIN


-- mehrere Tabellen miteinander logisch verknüpfen

-- Karthesisches Produkt

select * from lieferant cross join lieferung cross join artikel;

 -- alt:

 select * from lieferant, lieferung, artikel;


 -- Inner JOIN

 -- die Tabellen die am JOIN beteiligt sind werden über ihre Schlüsselspalten lolgisch miteinander verknüpft
 -- eine Verknüpfung über Domänengleiche Spalten (lstadt und die astadt) ist auch möglich

 --logische Gesamtaussage der Datenbank Standard
	-- Lieferanten liefern Artikel
	-- Artikel werden von Lieferanten geliefert

	select * from lieferant as a join lieferung as b on a.lnr = b.lnr join artikel as c on b.anr = c.anr;


	-- alle Angaben wo lieferanten aus Ludwigshafen im August 1990 rote Artikel geliefert haben

	select * from lieferant as a join lieferung as b on a.lnr = b.lnr join artikel as c on b.anr = c.anr
		where lstadt = 'ludwigshafen' and datepart (mm, ldatum) = 8 and DATEPART (yyyy, ldatum )= '1990' and farbe = 'rot';


-- Nummern und Namen der Lieferanten die geliefert haben

select a.lnr , lname from lieferant as a join lieferung as b on a.lnr = b.lnr;

-- Gibt der JOIN das Ergebnis nur einer am JOIN beteiligten Tabellen zurück, dann verwenden Sie den Operator distinct

select distinct(a.lnr) , lname from lieferant as a join lieferung as b on a.lnr = b.lnr;



-- Nummern und Namen der Lieferanten die nicht geliefert haben

select a.lnr , lname from lieferant as a join lieferung as b on a.lnr <> b.lnr;      -- FALSCH


-- die angezeigten 48 Datensätze ergeben keinen Sinn. Gegenprobe


select * from lieferant as a join lieferung as b on a.lnr <> b.lnr;   

--Diese Abfrage lösen wir mit einem OUTER-JOIN

-- Unterabfragen in der FROM-Klausel

--Gesucht sind die NUmmern und namen der lieferanten und die ANzahl wie oft sie geliefert haben, wenn sid mindestens 3x geliefert haben

select a.lnr, lname, anz
	from lieferant as a 
	join (select lnr, count(*) as [anz] from lieferung 
	group by lnr) as b
	on a.lnr = b.lnr where anz >= 3;


	-- oder 

	select distinct a.lnr, lname, count(*) as anz
	from lieferant as a 
	join lieferung as b 
	on a.lnr = b.lnr 
	group by a.lnr, lname having count(*) >= 3;



-- OUTER JOINS

/* eine Lieferung aufnehmen von einem LIeferanten den es nicht gibt
*/

insert into lieferung values ('L33', 'A05', 500, Getdate());    ---FEHLER

--Fremdschlüssel lnr_fs abschalten

alter table einkauf.lieferung drop constraint lnr_fs;     ---- GEHT JETZ
go

--Fremdschlüssel neu erstellen

alter table einkauf.lieferung with nocheck add constraint  lnr_fs foreign key (lnr) references verwaltung.lieferant (lnr);
go

-- LIeferanten mit ihren Lieferungen und auch die Lieferanten die noch nie geliefert haben.

select * from lieferant as a 
	left join lieferung as b
	on a.lnr=b.lnr;


-- LIeferanten mit ihren Lieferungen und auch die Lieferungen denen kein Lieferant zugeordnet werden kann.

select * from lieferant as a 
	right join lieferung as b
	on a.lnr=b.lnr;


-- LIeferanten mit ihren Lieferungen und Lieferanten die noch nie geliefert haben und auch die lieferungen den kein Lieferant zugeordnet werden kann.

select * from lieferant as a 
	full join lieferung as b
	on a.lnr=b.lnr;


-- LIeferanten die nie geliefert haben

select a.* 
	from lieferant as a 
	left join lieferung as b
	on a.lnr=b.lnr
	where b.lnr is null;




































