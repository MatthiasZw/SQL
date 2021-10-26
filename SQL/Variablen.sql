use standard
go

--Arbeit mit Variablen

-- werden deklariert mit Präfix @
-- Variablenname kann 128 Zeichen enthalten
-- variablen können nur an Stelle von Ausdrücken verwendet werden und nicht als Objektnamen
--Arrays müssen mit Dotnet Sprachen erstellt werden und im Server bereitgestellt werden
-- Variablen sind nur in dem Stapel gültig in dem sie erstellt werden

--Deklaration

declare @nr char(3) = 'L01', @ort varchar(200), @name varchar(200);

declare @rezept xml;
declare @lieferung xml;

declare @tab table(nr char(3), namen varchar(200), ort varchar(200));

-- Wertzuweisung zu Variablen

set @nr = 'L02';
select @name = lname, @ort = lstadt from lieferant where lnr = @nr;

set @rezept = '<kuchen>
				<mehl>200</mehl>
				<eier>6</eier>
				<zucker>150</zucker>
				</kuchen>';

set @lieferung = (select lieferant.lnr, lname, aname, ldatum from lieferant join lieferung on 
	lieferant.lnr = lieferung.lnr
	join artikel on lieferung.anr = artikel.anr
	for xml auto, root('Lieferung'),elements); 

insert into @tab select anr, aname, astadt from artikel;

print 'Der Lieferant ' + @name + ' wohnt in ' + @ort;

--select @rezept; 
--select @lieferung;

select * from @tab;







