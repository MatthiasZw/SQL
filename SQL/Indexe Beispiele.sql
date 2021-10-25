use standard

go

create table indtest
(lfdnr integer identity(1,3) not null,
namen char(50),
vname char(50));

declare @x int = 1;
while @x <= 1000000
begin 
	insert into indtest values('Drosten'  + cast (@x as char(50)),
						'Johannes' + cast (@x as char(50)));
	set @x +=1;
	end;
	go 




--	nicht gruppierter index

create index namen_ind on indtest(namen);

select * from 
sys.dm_db_index_physical_stats(db_id(),object_id('indtest'),null, null, null);


--erst wenn ein gruppierter index erstellt wird kommen daten aus heap in bessere (Indizierte) Struktur--


alter table indtest add constraint lfdnr_pk primary key (lfdnr);

select * from indtest;

