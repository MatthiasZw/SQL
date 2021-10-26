use standard
go

-- Try and Catch

--- Nur Schweregrade 10 bis 20
-- nicht im body von benutzerdefininierten funktionen

begin try
	begin
	 begin transaction banane
	 update lieferant set lstadt = 'Erfurt';
	 select 1/0;
	 commit transaction banane;
	end;
end try

begin catch
begin
  rollback transaction;
  select error_number() as [Fehlernummer], 
		error_message() as [Fehlertext], 
		error_severity() as [Schweregrad];
  end;
end catch;

select * from lieferant;

