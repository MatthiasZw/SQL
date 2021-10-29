use standard
go

/* Schreiben Sie eine Prozedur der eine Jahreszahl und optional ein Monat übergeben wird.
Wird der Prozedur nur die Jahreszahl übergeben, sollen alle Lieferungen des angegebenen Jahres
in eine Tabelle liefhist kopiert werden.
Wird zusätzlich noch ein Monat übergeben, sollen die Lieferungen des Monats für das angegebene Jahr kopiert werden.
Der Monat soll als Ziffer 01 bis 12, übergeben werden.
Führen Sie einee angemessene Fehlerbehandlung durch.*/

alter procedure liefhistory @jahr int, @monat int = null
as

drop table if exists liefhist; 

create table liefhist (Lnr char(3), ANr char(3), LMenge int, Ldatum date);

set @jahr = IIF (@jahr < 100 , @jahr + 1900, @jahr);

if (@monat is null)
	begin
		print('Test1');
		insert into liefhist (lnr, ANr, LMenge, Ldatum) select lnr, anr, lmenge, ldatum from lieferung where datepart(yy, ldatum)  = @jahr;	
		select * from liefhist;
	end;

else 
	begin 
		if (@monat between 1 and 12)
		begin
			print('Test2 ' + cast(@jahr as char(10)) + cast(datepart(mm,  @monat)  as char(10)));
			insert into liefhist (lnr, ANr, LMenge, Ldatum) select lnr, anr, lmenge, ldatum from lieferung where datepart(yy,  ldatum) = @jahr and datepart(mm, ldatum)= @monat;
			select * from liefhist
		end;
	else 
		begin
		raiserror ('Falscher Wert für Monat (1-12)!', 10, 1);
	end;
end;
	go

	exec liefhistory 90, 4;









