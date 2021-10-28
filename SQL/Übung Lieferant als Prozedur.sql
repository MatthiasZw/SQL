use standard
go

create procedure lieferungen @liefnummer char(3) = 'L01'
as


declare   @tabname_voll sysname, @tabname1 sysname, @tabname2 sysname, @a char(3), @b varchar(100), @c char(2), @d varchar(100);
declare @e char(3), @f varchar(100), @g int, @h date;
--declare @erg table(ANR char(3), ANM varchar(100), LM int, LDT date);


--set @tabname1 = 'lieferant';

if not exists (select * from lieferant where lnr= @liefnummer)
begin
raiserror('Der lieferant existiert nicht in der Datenbank', 10, 1);
return;
end;


--select @tabname_voll = a.name + '.' + b.name from sys.schemas as a join sys.tables as b on a.schema_id = b.schema_id 
--where b.name not like 'sys%' and b.name = @tabname1;


declare tab1 cursor for 

select lnr, lname, status, lstadt from  lieferant where lnr  = @liefnummer;

open tab1;

fetch tab1 into @a, @b, @c, @d;

print ('Lieferantennummer: ' + @liefnummer);
print ('Lieferantenname: ' + @b);
print ('Status: ' + @c);
print ('Wohnort: ' + @d);
print (' ');
print ('Der Lieferant hat folgende Lieferungen:');
print (' ');
Print ('Artiklenummer:          '   +   'Artikelname          '  + 'Liefermenge       ' + 'Lieferdatum          ' );

deallocate tab1;


declare tab2 cursor for 

select lieferung.anr, artikel.aname, lieferung.lmenge, lieferung.ldatum from  lieferung join lieferant on lieferant.lnr= lieferung.lnr join artikel on artikel.anr = lieferung.anr  where lieferung.lnr  = @liefnummer;

open tab2;

fetch tab2 into @e, @f, @g, @h;

while @@FETCH_STATUS = 0

begin
fetch tab2 into @e, @f, @g, @h;
	
print (@e +'                       '+cast(@f as char(10))+ '              '+ cast (@g as varchar(100)) +'            ' +cast(@h as varchar(100)))
 /*
print ('Artikelnummer' + @e);
print ('Artikelname' + @f);
print ('Liefermenge' + cast (@g as varchar(100)));
print ('Lieferdatum' + cast (@h as varchar(100)));
*/
end

deallocate tab2;


go

exec lieferungen 'L03';
