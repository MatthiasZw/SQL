use standard;
go

select * from lieferung;

--Case Ausdrücke

-- Wertet eine LIste von Werten oder Bedingungen aus und gibt ein Ergebbis oder einen Eregbnisausdruck
--SQL 92 Standard

--einfaches CASE
-- vergleicht einen Ausdruck mit mehreren anderen Ausdrücken (einfache) um ein Ergebnis zu bestimmen

select anr, aname, amenge, case astadt when 'Hamburg' then 'lagert im Norden' when 'Ludwigshafen' then 'lagert im Westen'
														else 'lagert auch'
														end as [Bewertung]
							from artikel;

-- komplexes Case

-- wendet eine Menge  Boolscher Ausdrücke an und wertet sie aus, und ermittelt daraus
-- ein Ergebnis
-- Bedingungen können sich auf mehrere Spalten der Tabelle beziehen
-- aufgebaut wie eine Bedingung in d3er where Klausel

select anr, aname, amenge, case
							when amenge between 0 and 600 then 'nachbestellen'
							when amenge between 601 and 1000 then 'unbedingt verkaufen'
							when amenge between 1001 and 1200 then 'verschenken'
							else 'wegwerfen'
							end as [Bewertung]
from artikel;


-- OFFSET und FETCH Funktion zum komplexen sortieren der Eregebnismenge

-- statt der TOP(n) - Funktion sollte OFFSET und FETCH verwendet werden

-- Die Option OFFSET gibt an, dien Anzahl der Datensätze die im Ergebnis übersprungen werden sollen
-- bevor das Ergebnis zurück gegeben wird
-- FETCH gibt die Anzahl der Zeilen an, die zurück gegeben werden sollen nachdem OFFSET verarbeitet wurde


--Beispiel:

--Gesucht sind die 5 Lieferungen, sortiert nach der Liefermenge absteigend nach den ersten drei
-- Lieferungen

select lnr, lmenge
from lieferung
order by lmenge desc
offset 3 rows fetch next 5 rows only;

-- Berechnen der Ergebnismenge

-- Modulo gibt den Divisionsrest zurück

select 5 % 2;    ----Rest 1

-- Nummern, Namen, Gewicht in Kilogramm und das Gesamtlagergewicht der jeweiligen Artikel

select anr, aname, gewicht * 0.001 as [Gewicht], 'Kilogramm' as [Gewichtseinheit], 
gewicht * 0.001 * amenge as [Gesamtlagergewicht], 'Kilogram' as [Lagergewichteinheit] from artikel;

-- Plus als Zeichenkettenverknüpfungsoperator

select 'Der Lieferant' + lname + '(' + lnr + '),  wohnt in ' + lstadt + 'und hat einen Status von: ' + cast(isnull(status, 0) as varchar(5))
from lieferant;

--deterministische Funktion immer selbes Ergebnis bei gleichen Eingaben

select pi();

-- nicht deterministisch zb 

select getdate(); 
 
 -----------------------------------------------------------------------------------

 select round(23.775, 1); ------ eine Stelle nach dem Komma
 select round(23.775, -1) ---------- eine Stelle nach dem Komma

 select rand()   ------- Wert zwischen 0 und 1
 select round(rand()*100, 0);

 -------------------------------------------------------------------------------------

 select lnr, lname, DATALENGTH(lname) from lieferant;   -- verwendete bytes
 select lnr, lname, len(lname) from lieferant;			-- Anzahl der Zeichen

 --delete lieferant where lnr > 'L05';

 select host_id();
select host_name();

select suser_name();             -- Login Name
select user_name();				-- Name in der Datenbank

select NEWID();


-----------------------------------------------------------------
--Zeichenfolgefunktionen

select char(39);

select replicate ('XXX', 200) as [Test];

select replace(lname, 'la', 'TTT' ) from lieferant;

select lname + space(30) + lstadt from lieferant;

-- den alphanumerischen teil asu der lieferantennummer herausschneiden

select lnr, substring(lnr, 1, 2) from lieferant;

-- den numerischen Teil herausschnieden
select lnr, cast(substring(lnr, 2, 2) as int) from lieferant;

---letzten drei Stellen des Wohnorts der Lieferanten

select lstadt, substring(lstadt, len(lstadt)- 2, 3) as [test] from lieferant order by lstadt desc ;

---------------------------------------------------------------------------------
--Datumsfunktionen

select getdate();
select GETUTCDATE();
select day(getdate());
select month(getdate());
select year(getdate());

--den letzten TAg des Monats im angegebenen Datum

select eomonth('23.02.2032');

-- erster Wochentag 
select @@DATEFIRST;
go

set language us_english;
select @@DATEFIRST;

set language german;

set language bavarian;

-- Datumsberechnungen

select dateadd(dd, +70, getdate());

-- Zahlungsziel 35 Tage nach Lieferdatum

select lnr, ldatum, dateadd(dd, 35, ldatum) as [Zahlungziel] from lieferung;

select datediff(dd, '09.07.1982', getdate());

-- Vor wievielen Monaten waren die lieferungen

select lnr, ldatum, datediff(mm, ldatum, getdate()) as [Monate] from lieferung;

select datename(yy, getdate()) --- das Ergebnis ist ein String;
select datename(dw, getdate()) --- das Ergebnis ist ein String;
select datename(mm, getdate()) --- das Ergebnis ist ein String;

select datepart (yy, getdate());

--alle Lieferungen vom August 1990

select * from lieferung where datepart(yy, ldatum)= 1990 and DATEPART(mm, ldatum) = 8;

-- Konvertieren von Datumswerten
-- verwenden Sie convert(), nicht cast()

-- Alle Lieferungen vom Juli 1990, dabei soll das Lieferdatum im deutschen Format (ohne Zeit) ausgegeben werden

select lnr, anr, convert(char(10), ldatum, 104) as [Lieferdatum] from lieferung where datepart(yy, ldatum) = 1990
and datepart(mm, ldatum) = 7;

--Übungen:

select  anr as [Artikelnummer], lmenge as [Liefermenge], datename(dw, ldatum) + ' der ' + datename(dd, ldatum) + '. ' + datename(mm, ldatum) + ' ' +  datename(yy, ldatum) as [Lieferdatum] from lieferung;



select anr as [Artikelnummer], convert (char(10), ldatum, 104) as [Lieferdatum], 'vor ' + convert(char(3), convert(int, datediff(dd, ldatum, getdate())/365), 104) + 'Jahren und ' + convert(char(3), convert(int, datediff(mm, ldatum, getdate())%12), 104) + 'Monaten.'  as [Die Lieferung war...] from lieferung;

--- Gruppieren und Zusammenfassen von Daten

-- Aggregatfunktionen

select MIN(lmenge) as [kleinste], MAX(lmenge) as[größte], SUM(lmenge) as [alle], avg(lmenge) as [durchschnitt], count(lmenge) as [anzahl werte] from lieferung;

-- gesucht ist der alphabetisch kleinste Lieferantenname

select min(lname) from lieferant;

-- kleinste LIefermenge des Artikels A="?

select min(lmenge) from lieferung where anr= 'A02';

-------------------------------------------------------------
insert into lieferant values ('L06', 'Friedrich', 10, null);
-----------------------------------------

-- Spezielle Attribute von Count

-- Count zählt Spaltenwerte oder Datensätze in der angegebenenenennnen Tabelle (count(*))

-- Anzahl der Lieferanten

select count(lnr) from lieferant;   --- liefert immer das richtige Ergebnis weil lnr Primärschlüssel ist

select count(*) from lieferant;   --- liefert immer das richtige Ergebnis weil die Datensätze der Tabelle gezählt werden

select count(lstadt) from lieferant;   -- beantwortet die Fragestellung falsch wenn in lstadt NULL-Marken enthalten sind

-- Distinct und Aggregatfunktionen

-- Anzahl der Lieferanten die geliefert haben

select count(distinct lnr) from lieferung;

select sum(distinct lmenge) from lieferung;          --- Sinnlos

--Aggregatfunktionen können nicht verschachtelt werden

select sum(avg(lmenge)) from lieferung;    ---Falsch

select sum(gewicht * 0.001) from artikel;


select max(lmenge), lnr from lieferung;    ---geht nicht

-- Alle Splaten in der Select_Liste die kein Argument einer Aggregatfunkton sind 
--müssen in einer GROUP BY clowsel stehen!

select max(lmenge), lnr from lieferung group by lnr;    --Änderung der Fragestellung: Die Größte Lieferung eines jeden Lieferanten

-- Wie oft hat jeder Lieferant geliefert?

select lnr, count(lnr) from lieferung group by lnr;

select lnr, count(*) from lieferung group by lnr;

select lnr, anr, count(*) from lieferung group by lnr, anr;

-- Where Klausel und Aggregaatfunktionen	

-- Gesucht: die größte Lieferung jedes Lieferanten die nach dem 23.7.1990 stattgefunden hat

select lnr, max(lmenge) from lieferung where ldatum > '23.07.1990' group by lnr;

-- Gesucht: die größte Lieferung jedes Lieferanten die nach dem 23.7.1990 stattgefunden hat und deren
--durchschnittliche Liefermenge mindestens 250 beträgt

select lnr, max(lmenge) from lieferung where ldatum > '23.07.1990' and avg(lmenge) >= 250 group by lnr;   --Fehler

-- In einer where Klausel dürfen keine Aggregatfunktionen stehen
-- dafür wird die Having-Klausel verwendet (where-Klausel der Group-by Klausel)

select lnr, max(lmenge) from lieferung where ldatum > '23.07.1990' group by lnr having avg(lmenge) >= 250;  


----------------Übungen:

select count(lnr) from lieferung where month(ldatum) = '08';

select count(lstadt) from lieferant;

select  lnr, min(lmenge) from lieferung group by lnr;

select min(lname) from lieferant where lname like 'S%';

use standard;
go

select max(amenge) as [Bestand], astadt as [Lagerort] from artikel group by astadt;



select astadt, count(distinct aname) as[Anzahl] from artikel group by astadt;

select  count(lnr) as [anzahl], anr from lieferung group by anr having count(lnr) <3 ;


select lnr, sum(lmenge) as[gesamt] from lieferung where ldatum > '13.07.1990' group by lnr having sum(lmenge)>600;

select max(status) as [max], min(status) as [min], lstadt from lieferant where lnr between 'L01' and 'L99' group by lstadt having min(status)>10 and  max(status) <= 50;


























