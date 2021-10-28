use standard
go

/* Schreiben Sie eine Prozedur der eine Jahreszahl und optional ein Monat �bergeben wird.
Wird der Prozedur nur die Jahreszahl �bergeben, sollen alle Lieferungen des angegebenen Jahres
in eine Tabelle liefhist kopiert werden.
Wird zus�tzlich noch ein Monat �bergeben, sollen die Lieferungen des Monats f�r das angegebene Jahr kopiert werden.
Der Monat soll als Ziffer 01 bis 12, �bergeben werden.
F�hren Sie einee angemessene Fehlerbehandlung durch.*/

alter procedure liefhistory @jahr int, @monat int = null
as

declare @liefhist table(Lnr char(3), ANr char(3), LMenge int, Ldatum date);

if (@monat is null)
	begin
		print('Test1');
		insert into @liefhist (lnr, ANr, LMenge, Ldatum) select lnr, anr, lmenge, ldatum from lieferung where datepart(yy, @jahr) +85 = @jahr;	
		select * from @liefhist;
	end;

else 
	begin 
		print('Test2 ' + cast(@jahr as char(10)) + cast(datepart(mm,  @monat)  as char(10)));
		insert into @liefhist (lnr, ANr, LMenge, Ldatum) select lnr, anr, lmenge, ldatum from lieferung where datepart(yy,  @jahr) + 85 = @jahr and datepart(mm, @monat)= @monat;
		select * from @liefhist
	end;

	go

	exec liefhistory 1990, 4;









