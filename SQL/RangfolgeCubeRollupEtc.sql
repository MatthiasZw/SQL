use standard;
go


select lnr, Datename(mm, ldatum) as [Monat], DATEPART(yyyy, ldatum ) as [Jahr], sum(lmenge) as [Gesamtliefermenge]
		from lieferung where lnr = 'L01' group by lnr, Datename(mm, ldatum), DATEPART(yyyy, ldatum )
		order by lnr, Datename(mm, ldatum), DATEPART(yyyy, ldatum );


--- Ergebnisse erweitern --> neue Aggregate für jede Dimension

-- Funktionen cube() und rollup()

--cube


select lnr, Datename(mm, ldatum) as [Monat], DATEPART(yyyy, ldatum ) as [Jahr], sum(lmenge) as [Gesamtliefermenge]
		from lieferung where lnr = 'L01' group by cube(lnr, Datename(mm, ldatum), DATEPART(yyyy, ldatum ))
		order by lnr, Datename(mm, ldatum), DATEPART(yyyy, ldatum );


		insert into lieferung values('L01', 'A03', 500, '11.05.2021')

-- rollup

select lnr, Datename(mm, ldatum) as [Monat], DATEPART(yyyy, ldatum ) as [Jahr], sum(lmenge) as [Gesamtliefermenge]
		from lieferung where lnr = 'L01' group by rollup(lnr, Datename(mm, ldatum), DATEPART(yyyy, ldatum ))
		order by lnr, Datename(mm, ldatum), DATEPART(yyyy, ldatum );


-- Rangfolgefunktionen

-- bezeichnen das Nummerieren von  Ergebniszeilen in einem Satz von Daten
-- anhand eines Rangfolgetyps

--für jede PArtitionszeile wird ein Rangfolgewert zurück gegeben

--rank()

--dense_rank()

--ntile()

--row_number()

-- RANK

--Rangfolge der Lieferanten anhand der Gesamtliefermenge

select a.lnr, lname, rank()over(order by sum(lmenge)desc) as[Rang], sum(lmenge) as [Gesamtliefermenge] from lieferant 
		as a join lieferung as b on a.lnr= b.lnr group by a.lnr, lname; 

insert into lieferung values('L02', 'A06', 200, GETDATE());

-- bei gleichen Partitionswerten entstehen in der Rangfolge Lücken

--dense_rank()

select a.lnr, lname, dense_rank()over(order by sum(lmenge)desc) as[Rang], sum(lmenge) as [Gesamtliefermenge] from lieferant 
		as a join lieferung as b on a.lnr= b.lnr group by a.lnr, lname; 

		-- Keine Lücken in der Rangfolge

-- ntile
-- Verteil die Zeilen in einer sortierten Partition in eine angegebene Anzahl von Gruppen

-- Liefermengenbereiche bilden und eine Zuordnung der jeweils gelieferten Artikel entsprechend
--der LIefermenge vornehmen

select ntile(4) over(partition by aname order by lmenge) as [Mengenkategorie],
	aname, lmenge
	from artikel as a join lieferung as b on a.anr = b.anr
	order by aname;

	--ROW NUmber

	-- Wenn die Datensätze fortlaufend nummeriert werden sollen

	-- Zeilennummern für jeden LIeferanten

select row_number() over(order by lnr desc) as [Laufende Nr.:],  lname, lstadt from lieferant;














