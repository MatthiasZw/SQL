use standard;
go

--- Benutzerdefinierte Funktionen

-- create, alter , drop function
-- execute berechtigungen nötig
-- kein try catch möglich, kein execute as möglich
-- kein raiserror möglich

-- skalar und inline

-- declare, cursor, if,  while, select, update etc

-- Skalarfunktion gibt immer einen Wert zurück

-- eine Funktion die ermittelt wie oft ein Artikel in einem bestimmten Zeitraum geliefert wurde

create function antanz(@nr char(3), @begdat date, @enddat datetime)
returns int
as
begin
	declare @anzahl int;
	select @anzahl = count(*) from lieferung where anr= @nr and ldatum between @begdat and @enddat group by anr;

	return @anzahl;
end;
go
	
select dbo.antanz('A02', '05.08.90', '20.08.90');


-- Gesucht sind die Artikel die öfters geliefert wurden wie Artikel A02 im Zeitraum vom 5.8.90 bis 20.8.90


select aname from artikel where anr in (select anr from lieferung group by anr having count (*) > (select dbo.antanz('A02', '05.08.90', '20.08.90')));

go


---Übung: Schreiben Sie eine Skalare Funktion, welcher Sie ein Datum übergeben und ein Zeichen.
-- Die Ausgabe sollte wie folgt aussehen:
-- 29-10-2021 (Datum und Bindestrich wurde übergeben


alter function datum (@date date, @z varchar(2))
returns char(20)
as
	begin
	declare @a varchar(20)
	declare @b varchar(20)
	declare @c varchar(20)
	declare @d varchar(20);

	
	select @a = cast(datepart(dd, @date) as varchar(20));
	select @b = cast(datepart(mm, @date) as varchar(20));
	select @c = cast(datepart(yyyy, @date) as varchar(20));

	
	set @d = @a+@z+@b+@z+@c;

	

	return @d;
end;
go

select dbo.datum(getdate(), 'z'); 
go


--- Inline Funktion mit Tabellenrückgabe

-- kann nur eine SQL-Anweisung im Body haben, darum auch kein begin und end
-- die Rückgabe ist immer vom Typ Table
-- Dabei hat die zurück gegebene Tabelle immer die Struktur der Abfrage im Body der Funktion

-- hat die Funktionalität einer Sicht, aber sie arbeitet mit Parametern

create function liefinf(@begindat datetime, @enddat datetime)
returns table
as
return(select distinct lname, lstadt from lieferant as a join lieferung as b on a.lnr = b.lnr where ldatum between @begindat and @enddat);
go


select * from dbo.liefinf('01.08.90', '18.08.1990') where lstadt like 'H%';
go

-- Funktionen mit mehreren Anweisungen und Tabellenrückgabe (Tabellenwertfunktionen)

-- die Funktionalität entspricht der einer parameterisierten Sicht und der einer gespeicherten Prozedur


create function  uebersicht(@tabname sysname = 'lieferant')
returns @tab table (nr char(3), namen varchar(20), orte varchar(20))
as
begin 
	if @tabname not in ('lieferant', 'artikel')
	return

	if @tabname = 'lieferant'
		insert into @tab select lnr, lname, lstadt from lieferant;
	if @tabname = 'artikel'
		insert into @tab select anr, aname, astadt from artikel;

	return;
end;
go

select * from dbo.uebersicht('artikel');

select * from dbo.uebersicht('lieferant');

select * from dbo.uebersicht(default);
go