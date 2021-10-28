use standard
go 

-- gespeicherte Systemprozeduren
-- beginnen mit dem Präfix sp_

-- damit können Daten aus den Systemtabellen abgerufen werden
-- alle gespeicherten Systemprozeduren sind in allen Datenbanken abrufbar
-- gespeicherten Systemprozeduren können Parameter-Werte übergeben werden oder auch nicht.
-- einen Großteil von gesp. Systemprozeduren kann der sysadmin editieren

exec sp_help;             -- zeigt alle objekte der aktuellen Datenbank
exec sp_help 'lieferant'; -- zeigt alle infos zum angegebenen Datenbankobjekt


-- Erweiterte gespeicherte Prozeduren
-- befinden sich in der Master-datenbank
-- beginnen in der Regel mit präfix xp_ 
-- kein T-SQL sondern in der Regel DLLs die in einer Programmiersprache wie z.B C# geschrieben wurden
-- diese Prozeduren sind nur noch aus Gründen der Abwärtskompatibilität verfügbar
-- Diese Art von Prozeduren sollten in einer CLR- Integration (.NET Frameworkfähige Programmiersprache) verwendet werden

--Servereigenschaften anzeigen und einstellen

exec sp_configure;								--- zeigt grundelegende einstellungen an
go
exec sp_configure 'show advanced option', 1;
go
reconfigure;

exec sp_configure;								--- zeigt jetzt alle einstellungen an

exec sp_configure 'xp_cmdshell', 1;
go
reconfigure;
go

exec xp_cmdshell 'dir c:';


-- Benutzerdefinierte gespeicherte Prozeduren
-- werden in einer Datenbank erstellt und stehen nur dort zur Verfügung
-- sie besitzen einen eindeutigen Namen
-- der Name sollte nicht mit dem Präfix sp_ oder xp_ beginnen

use standard;
go

--Anhand einer Prozedur Mathe  die Möglichkeiten bei der Programmierung aufzeigen

create procedure mathe 
as
declare @zahl1 float, @zahl2 float, @erg float;
set @zahl1 = 56.44;
set @zahl2 = 23.99;
set @erg = @zahl1 / @zahl2;

print('Ergebnis:   ' + cast(@erg as varchar (50)));
go

--Aufruf der Prozedur

exec mathe;
go

-- Ändern

alter procedure mathe 
as
declare @zahl1 float, @zahl2 float, @erg float;
set @zahl1 = 300;
set @zahl2 = 23.99;
set @erg = @zahl1 / @zahl2;

print('Ergebnis:   ' + cast(@erg as varchar (50)));
go

-- Die prozedur wird gespeichert in sys.objects und der quelltext der Prozedur in sys.sql_modules
-- Der Quelltext kann mit der Option "with encryption" verschlüsselt werden so dass er von dritten nicht 
-- einzusehen ist. (Aufheben!)

-- Der Prozedur die Parameter Zahl1 und Zahl2 übergeben

create procedure mathe1 @zahl1 float, @zahl2 float
as
declare @erg float;
set @erg = @zahl1 / @zahl2;

print('Ergebnis:   ' + cast(@erg as varchar (50)));
go

exec mathe1 34.9, 3.8;
go


---Der Prozedur Default-werte zuweisen

create procedure mathe2 @zahl1 float = 1, @zahl2 float = 1
as
declare @erg float;
set @erg = @zahl1 / @zahl2;

print('Ergebnis:   ' + cast(@erg as varchar (50)));
go

exec mathe2;
go

exec mathe2 39, 50 ;
go

-- Die Prozedur soll das Ergebnis an das aufrufende Programm zurück geben

create procedure mathe3 @zahl1 float = 1, @zahl2 float = 1, @erg float output
as
set @erg = @zahl1 / @zahl2;
go

declare @wert1 float, @wert2 float, @ergebnis float;
set @wert1 = 344.5;
set @wert2 = 45.99;

exec mathe3 @wert1, @wert2, @ergebnis output;
print('Ergebnis:   ' + cast(@ergebnis as varchar (50)));
go

--Prozedur absichern. Wenn Zahl2 eine Null ist soll ein Fehler zurück gegeben werden

create procedure mathe4 @zahl1 float = 1, @zahl2 float = 1, @erg float output
as
if @zahl2 = 0
begin
raiserror('Du sollst nicht durch null teilen!', 10, 1);
return;
end;
set @erg = @zahl1 / @zahl2;
go

--Testen

declare @wert1 float, @wert2 float, @ergebnis float;
set @wert1 = 344.5;
set @wert2 = 0;

exec mathe4 @wert1, @wert2, @ergebnis output;
print('Ergebnis:   ' + cast(@ergebnis as varchar (50)));
go


--Prozedur elegANT	absichern. Wenn Zahl2 eine Null ist soll ein Fehler zurück gegeben werden

create procedure mathe5 @zahl1 float = 1, @zahl2 float = 1, @erg float output
as
if @zahl2 = 0
begin
return 2;
end;
set @erg = @zahl1 / @zahl2;
go

--Testen

declare @wert1 float, @wert2 float, @ergebnis float, @rw int;
set @wert1 = 344.5;
set @wert2 = 0;

exec @rw= mathe5 @wert1, @wert2, @ergebnis output;
if @rw=2 
begin
raiserror('Du sollst nicht durch Null teilen', 10,1);
return;
end;
print('Ergebnis:   ' + cast(@ergebnis as varchar (50)));
go








































