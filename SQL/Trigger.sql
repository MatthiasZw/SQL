use standard;
go

-- Beim Aufnehmen einer neuen Lieferung soll die Liefermenge des Artiklels zu seiner Lagermenge addiert werden

create trigger liefneu on lieferung 
after insert 
as
update artikel set amenge = amenge + lmenge from artikel as a join inserted as b on a.anr = b.anr;
go


select * from artikel where anr = 'A03';   ----------------------amenge = 400
insert into lieferung values('L04', 'A03', 500, getdate());

select * from artikel where anr = 'A03';   ----------------------amenge = 900
go

--- Wird eine Lieferung gelöscht soll die Lagermenge des entsprechenden Artikéls korrigiert werden


create trigger liefweg on lieferung
after delete 
as
update artikel set amenge = amenge - lmenge from artikel as a join deleted as b on a.anr = b.anr;

go


select * from artikel where anr = 'A03';   ----------------------amenge = 900
delete lieferung where lmenge = 500 and anr = 'A03';

select * from artikel where anr = 'A03';   ----------------------amenge = 400
go



--- Ändern der LAgermenge wenn sich die Artikelnummer bei einer LIeferung aändert

insert into lieferung values ('L01', 'A04', 500, GETDATE());
go 

create trigger anrfalsch
on lieferung
for update
as

update artikel set amenge = amenge - lmenge from artikel as a join deleted as b on a.anr = b.anr;

update artikel set amenge = amenge + lmenge from artikel as a join inserted as b on a.anr = b.anr;
go

select * from artikel where anr = 'A04'; -----------------------------amenge 1400
select * from artikel where anr='A05';  --------------------------------amenge 1300

update lieferung
set anr = 'A05' where lnr = 'L01' and anr = 'A04' and lmenge = 500;

select * from artikel where anr = 'A04'; -----------------------------amenge 900
select * from artikel where anr='A05';  --------------------------------amenge 1800
go

---Instead of Trigger

create view v_lieflief
as 
select a.lnr, lname, status, lstadt, anr, lmenge, ldatum from lieferant as a join lieferung as b on a.lnr = b.lnr;
go

select * from v_lieflief;
go

alter table lieferant drop constraint vers_nr_unq;
alter table lieferant drop column vers_nr;
go

create trigger tr_lieflief
on v_lieflief
instead of insert 
as
	if not exists(select*from lieferant as a join inserted as b on a.lnr = b.lnr)
	begin 
		insert into lieferant select lnr, lname, status, lstadt from inserted;
		insert into lieferung select lnr, anr, lmenge, ldatum from inserted;
	end;
	else
	insert into lieferung select lnr, anr, lmenge, ldatum from inserted;
go 



insert into v_lieflief values('L55', 'Walter', 10, 'Erfurt', 'A02', 500, GETDATE());
insert into v_lieflief values('L55', 'Walter', 10, 'Erfurt', 'A03', 500, GETDATE());

go

select a.lnr, lname, status, lstadt, anr, lmenge, ldatum from lieferant as a join lieferung as b on a.lnr = b.lnr where a.lnr='L55';    
go


--DDL Trigger

create trigger view_del
on database 
for drop_view
as
	raiserror('Du sollst nicht löschen fremder Leute Eigentum', 10, 1);
	rollback;
go

drop view v_lieflief;






