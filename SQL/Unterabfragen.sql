---einfache Unterabfrage

use standard;
go

-- Alle Artikel deren Lagermenge über der durchschnittlichen Lagermenge aller Artikel lieget

--1. Frage -- wie geroß ist die durchschnittliche Lagermenge aller artikel

select avg(amenge) from artikel;

--2. Frage -- welcher Artikle hat eine größere Lagermenge?

select * from artikel
	where amenge > (select avg(amenge) from artikel);


	-- Die Namen und Wohnorte aller Lieferanten die geliefert haben

	--1. Frage wer hat geliefert

	select lnr from lieferung;

	-- 2. Frage wie sind die namen dieser lieferanten
	
	select lname, lstadt from lieferant where lnr	in(select lnr from lieferung);

	-- als Operator kommt kein vergleichsoperator zur Anwendung weil die Unterabfrage 
	-- mehr als einen Wert liefert. Wir verwenden deshalbden Operator IN()


	--Die Namen der Lieferanten die im August 1990 blauea artikel geliefert haben

	select anr from artikel where farbe= 'blau';

	select lnr from lieferung where datepart(yy, ldatum)= 1990 and DATEPART(mm, ldatum) = 8; ;

	select lname from lieferant where lnr in (select lnr from lieferung where datepart(yy, ldatum)= 1990 and DATEPART(mm, ldatum) = 8 and anr in (select anr from artikel where farbe= 'blau')); 


	select lname from lieferant where lnr in (select lnr from lieferung where ldatum between '1.8.1990' and '1.9.1990' and anr in(select anr from artikel where farbe ='blau'));


	-- Gesucht sind die namen und wohnorte der lieferanten deren statuswerte über dem durchschnittlichen statuswert der lieferanten liegt, welche in der gleichen stadt wohnen wie lieferant L02


	select lname, lstadt from lieferant where status > (select avg(status) from lieferant where lstadt = (select lstadt from lieferant where lnr='L02'));

	-- Gesucht sind die HAmburger Lieferanten die öfter geliefert haben wie blaue artikel geliefert wurden.





	select lname from lieferant where lstadt ='hamburg ' and  lnr in( select lnr from lieferung where (select count(lnr) from lieferung) > (select count (anr) from lieferung where anr in(select anr from artikel where farbe='blau')))
	
	
	
	-- haben blaue artikel geliefert: 
	
	lnr in (select lnr from lieferung where anr in(select anr from artikel where farbe='blau'));


	
	







-- korrellierte Unterabfrage Abfrage (rechenaufwändig, eher vermeiden)