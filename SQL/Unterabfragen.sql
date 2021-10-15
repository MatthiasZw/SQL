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


	select lname from lieferant where lstadt ='hamburg' and  lnr in( select lnr from lieferung group by lnr having count(*) > (select count (*) from lieferung where anr in(select anr from artikel where farbe='blau'))); 
	
	--<-- stimmt scheinbar jetz


	-- Gesucht sind die namen und Lagerorte der Artikel deren letzte Lieferung an dem Tag erfolgt ist, an dem auch artikel 'A02' letztmalig geliefert wurde

	insert into lieferung values('L02', 'A05', 500, '09.08.1990');

	

	 select aname, astadt from artikel where anr in(select anr from lieferung group by anr having max(ldatum) in(select max(ldatum) from lieferung where anr='A02'));

	 delete lieferung where datepart(yyyy, ldatum) > 1990 or lmenge = 500;
	
	select * from lieferung;

	delete lieferant where lnr > 'L05';



	--Gesucht sind nummer, name und Wohnort der Lieferanten die jeden artikel geliefert haben

	select lnr, lname, lstadt from lieferant where lnr in(select lnr from lieferung group by lnr having count(distinct anr) = (select count(anr) from artikel));


	-- Gesucht ist das Liefedatum, wo hamburger Lierferanten in deren Namen ein i oder ein l vorkommt, rote oder blaue artikel mit einem gewicht über 15 gramm geliefert haben



	select anr from artikel where (farbe='rot' or farbe= 'blau') and Gewicht > 15;

    select lnr from lieferant where lname like '%i%' or  lname like '%l%');

	select ldatum from lieferung where anr in(select anr from artikel where (farbe='rot' or farbe= 'blau') and Gewicht > 15);



	select ldatum from lieferung where ldatum in (select ldatum from lieferung where anr in(select anr from artikel where (farbe='rot' or farbe= 'blau') and Gewicht > 15) and  lnr in(select lnr from lieferant where lname like '%i%' or  lname like '%l%' and lstadt = 'hamburg'));             



	-- Gesucht sind die Artikel mit einer Lagermenge von mindestens 500 stück die öfters geliefert wurden 
	-- wie LIeferanten aus Ludwigshafen im August 1990 geliefert haben

	--- Anzahl  aller Artiklellieferungen aus ludwigshafen im august

	select count(distinct anr) from lieferung where lnr in(select lnr from lieferant where lstadt = 'Ludwigshafen') and ldatum between '1.8.1990' and '31.8.1990'; 


	select aname from artikel where amenge > 500 and anr in (select anr from lieferung group by anr having count(lnr)  > (select count(anr) from lieferung where lnr in(select lnr from lieferant where lstadt = 'Ludwigshafen') and ldatum between '1.8.1990' and '31.8.1990')); 


	


	
	







-- korrellierte Unterabfrage Abfrage (rechenaufwändig, eher vermeiden)