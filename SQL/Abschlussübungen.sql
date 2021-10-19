

--- 1. daten aller Lieferanten aus Ludwigshafen

select * from lieferant where lstadt = 'ludwigshafen';

---2. Nummern, Namen, Lagerorte aller gelieferten Artikel?

select anr, aname, astadt from artikel where anr in (select anr from lieferung where lmenge > 0);

--3. Nummern und Namen aller Artikel und ihr Gewicht in kg

select anr, aname, gewicht /1000 as[gewicht in kg] from artikel;

---4. Namen aller Lieferanten aus Aachen mit mit statuswert zwischen 20 und 30

select  lname from lieferant where status between 20 and 30;

---5. Nummern und Namen aller Artikel deren Gewicht 12, 14, oder 17 gramm beträgt;

select anr, aname from artikel where gewicht = 12 or gewicht = 14 or gewicht = 17;

---6. Daten aller LIeferungen von Lieferanten aus Hamburg

select * from lieferung where lnr in( select lnr from lieferant where lstadt = 'Hamburg');

---7. Artikelnummern, Artikelnamen und Lieferantennummern und Lieferantennamen mit übereinstimmendem Lagerort und Wohnort

select a.lnr, a.lname, c.aname, b.anr from lieferant as a join (select lnr, anr from lieferung) as b on a.lnr = b.lnr join (select anr, astadt, aname from  artikel) as c on b.anr = c.anr where a.lstadt = c.astadt;

--- 8. Artiklenummern, Artikelname und Lagerort aller gelieferten Artikel und Lieferantennummer, Lieferantenname und Wohnort des jeweiligen LIeferanten sofern Lagerort und Wohnort übereinstimmen

select a.lnr, a.lname, c.aname, c.astadt, b.anr, a.lstadt from lieferant as a join (select * from  lieferung) as b on a.lnr = b.lnr join (select * from  artikel) as c on b.anr = c.anr where a.lstadt = c.astadt;



---9. Paare von Artikelnummern, von Artikeln mit gleichem Lagerort (Jedes Paar soll nur einmal ausgegeben werden)

select a.anr, b.anr from artikel as a join artikel as b on a.astadt=b.astadt  and a.anr>b.anr; 



---10 Nummern aller Lieferanten die mindestens einen Artikel geliefert haben den auch 'L03' geliefert hat

 select lnr from lieferung where anr in(select anr from lieferung where lnr ='L03');


--- 11. Nummern aller Lieferanten die mehr als einen Artikel geliefert haben

select lnr from lieferung group by lnr having count(anr) >1;


---12. Nummern und Namen der Artikel die am selben Ort wie 'A03' gelagert werden

select anr, aname from artikel where astadt in(select astadt from artikel where anr ='L03');

---13. Durchschnittliche Liefermenge des Artikels A01

select avg(lmenge) from lieferung where anr = 'A01'; 

--14. Gesamtliefermenge aller Lieferungen des Artkels A01 die L02 geliefert hat

select sum(lmenge) from lieferung where anr = 'A01' and lnr='L02';

--15. Lagerorte der Artikel die L02 geliefert hat

select astadt from artikel where anr in( select anr from lieferung where lnr='L02');

---16. Nummern und Namen der Lieferanten, deren Statuswert kleiner als der von L03 ist

select lnr, lname from lieferant where status < (select status from lieferant where lnr='L03');

--- 17. Nummern aller Lieferanten, welche die gleichen artikel wie L02 geliefert haben

select distinct lnr from  lieferung where anr in (select anr from lieferung where lnr ='L02');

---18 Die NAmen aller Orte die Lagerort von Artikeln oder Wohnort von Lieferanten sind

select   lstadt from lieferant  union select astadt from artikel;

---19. Nummern und Namen aller Lieferanten die nicht den Artikel 05 geliefert haben

select lnr, lname from lieferant where lnr  not in(select lnr from lieferung where anr = 'A05');

--- 20. Lnr und Lname die alle Artikel geliefert haben

select lnr, lname from lieferant where lnr in(select lnr from lieferung group by lnr having count(distinct anr) = (select count(anr) from artikel));


--21. Nummern, Name und Wohnort der Lieferanten die bereits geliefert haben und deren Statuswert 
---   größer ist als der kleinste Statuswert aller Lieferanten

select lnr, lname, lstadt from lieferant where lnr in(select lnr from lieferung group by lnr having status > (select min(status) from lieferant));

---22. Nummern und Bezeichnungen aller Artikel, deren durchschnittliche Liefermenge kleiner als des Artikels 'A03' ist

select anr, aname from artikel where anr in (select anr from lieferung group by anr having avg(lmenge) < (select lmenge from lieferung where anr ='A03'));

---23. Lieferantennummer, Lieferantenname, Artiklenummer und Artikelbezeichnung aller Lieferungen, 
--- die seit dem 5.5.1990 von Hamburger Lieferanten geliefert wurden

select lieferung.lnr, lname, lieferung.anr, artikel.aname from lieferung join lieferant on lieferung.lnr = lieferant.lnr join artikel on lieferung.anr = artikel.anr where ldatum > '05.05.1990';

---24. Anzahl der Lieferungen, die seit dem 5.5.1990 von Hamburger Lieferanten geliefert wurden

select count(lnr) from lieferung where lnr in( select lnr from lieferant where lstadt = 'hamburg') and ldatum > '05.05.1990';

--- 25. Ortsnamen die Wohnort aber nicht Lagerort sind

select lstadt from lieferant except (select astadt from artikel);

--- 26. Ortsnamen die sowohl Wohnort als auch Lagerort sind

select lstadt from lieferant intersect (select astadt from artikel);









