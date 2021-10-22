use master
go

create database Forschung
on primary (name= forschung_kat,
			filename = 'e:\dbdaten\forschung_kat.mdf',
			size = 1 GB,
			maxsize = 20 GB,
			filegrowth = 500 MB),
filegroup aktiv (name= forschung_daten1,
			filename = 'h:\daten\forschung_daten1.ndf',
			size = 1 GB,
			maxsize = 20 GB,
			filegrowth = 500 MB),
filegroup passiv (name= forschung_daten2,
			filename = 'h:\daten\forschung_daten2.ndf',
			size = 1 GB,
			maxsize = 20 GB,
			filegrowth = 500 MB)
log on (name= standardlogforschung,
			filename = 'f:\dbprotokoll\standardlogforschung.ldf',
			size =  200 MB ,
			maxsize = 20 GB,
			filegrowth = 10 %);

go

alter database forschung modify filegroup passiv default;
go


use forschung;
go


create table orte
(ortid bigint not null,   ------->intergalaktische Ort-Id
plz bigint not null,
ortsname varchar(500) not null);
go


create table abteilung
(abt_nr bigint not null,
abt_name varchar(100) not null,
ortid bigint not null);

go


create table mitarbeiter
(m_nr bigint not null identity (1000,1),
m_name varchar(100) not null,
m_vorname varchar(100) not null,
ortid bigint not null,
strasse varchar(100) null,
geb_dat date not null,
abt_nr bigint null);

go


create table telefon
(m_nr bigint not null,
vorw bigint not null,
tel_nr bigint null);

go


create table projekt
(pr_nr bigint not null,
pr_name varchar (100) not null,
mittel int null);

go


create table arbeiten
(m_nr bigint not null,
pr_nr bigint not null,
aufgabe varchar(50) null,
einst_dat date null) 
ON aktiv ;

go


alter table orte add constraint ortid_pk primary key(ortid);
go

alter table abteilung add constraint abt_nr_pk primary key(abt_nr);
go

alter table arbeiten add constraint arb_pk primary key(m_nr, pr_nr);
go

alter table mitarbeiter add constraint mit_pk primary key(m_nr);
go

alter table projekt add constraint pro_pk primary key(pr_nr);
go


ALTER TABLE telefon
ALTER COLUMN tel_nr bigint not NULL;
go

alter table telefon add constraint tel_pk primary key( vorw, tel_nr);
go

alter table abteilung add constraint abt_fk foreign key(ortid) references orte(ortid);
go

alter table arbeiten add constraint arb_fk foreign key(m_nr) references mitarbeiter(m_nr);
go

alter table arbeiten add constraint arb2_fk foreign key(pr_nr) references projekt(pr_nr);
go

alter table telefon add constraint tel_fk foreign key(m_nr) references mitarbeiter(m_nr);
go

 

alter table mitarbeiter add constraint mit_fk foreign key(ortid) references orte(ortid);
go

alter table mitarbeiter add constraint mit2_fk foreign key(abt_nr) references abteilung(abt_nr);
go


 alter table abteilung add constraint ant_nr_chk check(abt_nr between 'a1' and 'a50');

 alter table projekt add constraint pr_nr_chk check(pr_nr between 'p0' and 'p150');


ALTER TABLE projekt
ALTER COLUMN mittel int not NULL;
go

 alter table projekt add constraint mittel_chk check(mittel <= 2000000);

 alter table orte add constraint ortid_chk check(ortid like '[Erfurt] [Weimar] [Jena] [Gotha] [Suhl] [Nordhausen] [Sömmerda]');

 alter table orte add constraint plt_chk check(plz like '[0-9][0-9][0-9][0-9][0-9]');

 alter table arbeiten add constraint einst_dat_chk check(einst_dat between getdate() and getdate()-7);

 alter table orte add constraint ortsname_chk check(ortsname like '[A-Z]%');

 alter table mitarbeiter add constraint m_name_chk check(m_name like '[A-Z]%');
 alter table mitarbeiter add constraint m_vorname_chk check(m_vorname like '[A-Z]%');
 alter table arbeiten add constraint aufgabe_chk check(aufgabe like '[A-Z]%');
 alter table projekt add constraint pr_name_chk check(pr_name like '[A-Z]%');
 alter table abteilung add constraint abt_name_chk check(abt_name like '[A-Z]%');

 
 /*drop database forschung;
 go*/

 

