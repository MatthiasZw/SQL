use standard;
go

--Literale (erläuternder Text)

select anr, aname, gewicht, 'Gramm', amenge, 'Stück' from artikel;

-- Spaltennamen ändern

select anr as [Artikelnummer], aname as[Artikelname], gewicht as [Gewicht], 'Gramm' as [Gewichtseinheit], amenge as [Lagermenge], 'Stück' as [Lagereinheit] from artikel;

select anr [Artikelnummer], aname [Artikelname], gewicht [Gewicht], 'Gramm'  [Gewichtseinheit], amenge  [Lagermenge], 'Stück'  [Lagereinheit] from artikel;

select [Artikelnummer] = anr, [Artikelname] = aname, [Gewicht] = gewicht, [Gewichtseinheit] = 'Gramm', [Lagermenge] = amenge, [Lagereinheit]= 'Stück' from artikel;

--Entfernen doppelter Datensätze in der Ergebnismenge

-- Welche Lieferanten haben geliefert?

select lnr from lieferung

select distinct lnr from lieferung;   -- sinnlos bei primärschlüsseln

-- IN welchen Orten lagern Artikel

select distinct astadt from artikel;


-- Sortieren der Ergebnismenge

select anr as [Artikelnummer], aname as[Artikelname], astadt as [Lagerort], gewicht as [Gewicht], 'Gramm' as [Gewichtseinheit], amenge as [Lagermenge], 'Stück' as [Lagereinheit] from artikel;

-- Das Ergebnis soll nach dem Artikelnamen aufsteigend sortiert sein und bei gleichen Artikelnamen soll nach dem Lagerort absteigend sortiert werden

select anr as [Artikelnummer], aname as[Artikelname], astadt as [Lagerort], gewicht as [Gewicht], 'Gramm' as [Gewichtseinheit], amenge as [Lagermenge], 'Stück' as [Lagereinheit] from artikel
order by aname asc, astadt desc;

select anr as [Artikelnummer], aname as[Artikelname], astadt as [Lagerort], gewicht as [Gewicht], 'Gramm' as [Gewichtseinheit], amenge as [Lagermenge], 'Stück' as [Lagereinheit] from artikel
order by Artikelname asc, Lagerort desc;

select anr as [Artikelnummer], aname as[Artikelname], astadt as [Lagerort], gewicht as [Gewicht], 'Gramm' as [Gewichtseinheit], amenge as [Lagermenge], 'Stück' as [Lagereinheit] from artikel
order by 2 asc, 5 desc;
