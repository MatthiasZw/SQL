use standard
go

-- Dynamische Anweisungen und Aggregatfunktionen

-- Sie möchten mit einer dynamischen Anweisung die Anzahl der Lieferungen eines bestimmten Lieferanten ermitteln
	--Weiterhin wollen Sie mit dem ermittelten Wert im Stapelprogramm weiter arbeiten

/*
declare @nr char(3), @sql varchar(max), @hk char(1)= char(39); 

set @nr= 'L01';
set @sql = ('select count(*) from lieferung where lnr = ' + @hk + @nr + @hk);
select @sql;
exec(@sql); 
*/

-- funktioniert, der Wert wird angezeigt, aber mit diesem Wert kann man nicht weiter rechnen

-- Wie kann man das lösen?

set nocount on;

declare @nr char(3), @sql varchar(max), @hk char(1)= char(39),@zahl int; 
declare @anz table(anzahl int);

set @nr= 'L01';

set @sql = ('select count(*) from lieferung where lnr = ' + @hk + @nr + @hk);

insert into @anz exec(@sql);

select @sql;
exec(@sql); 

set @zahl = (select anzahl from @anz);
print @nr + ' hat ' + cast (@zahl as varchar (5)) + ' x geliefert.'

set nocount off;

go


