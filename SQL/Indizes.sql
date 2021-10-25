use standard
go

select * from lieferant;

/* Die Tabelle lieferung in eine Dateigruppe aktiv zu verschieben.*/

-- Da die Dateigruppe nicht existiert muss sie erst erstellt werden--

alter database standard add filegroup aktiv;
go

--- Eine Datei in die Dateigruppe legen---

alter database standard 
add file (name = standard_daten2, 
			filename = 'j:\daten\standard_daten2.ndf',
			size = 1 GB, 
			maxsize = 15 GB) to filegroup aktiv;

go

exec sp_helpdb standard;
go

use standard
go

-- Primary Key der Tabelle lieferung verschieben--

-- Schritt 1 - Primary Key löschen--

alter table lieferung drop constraint lief_pk;

-- Schritt 2 - Primary Key erstellen--

alter table lieferung add constraint lief_pk primary key (lnr, anr, ldatum) on aktiv;

-- test

exec sp_help 'artikel';


-------------------------------------------------------------------------------

insert into artikel values('A07', 'Unterlegscheibe', 'schwarz', 3, 'Erfurt',100);

select * from lieferung;

select aname, astadt from artikel where farbe = 'rot';


create index farbe_ind on artikel (farbe);

drop index artikel.farbe_ind;

create index art_ind on artikel (farbe, aname, astadt);

drop index artikel.art_ind;


--- Included Index---


create index art_ind on artikel(farbe) include (aname, astadt);


---Fremdschlüsselspalten indizieren---

create index lnr_ind on lieferung (lnr);
go
create index anr_ind on lieferung (anr);
go


---Indizes neue erstellen--

alter index art_ind on artikel rebuild;

--oder

create index art_ind on artikel (farbe) include (aname, astadt) with (drop_existing = on);

--eignet sich hervorragend für die erstellung von clustered indizes

-- alle Indizes einer Tabelle neu erstellen:

alter index all on lieferung rebuild;

-- Neuorganisation von Indizes:

alter index art_ind on artikel reorganize;

/*Bei einem Fragmentierungsgrad des indexes <= 30% wird der Index neu organisiert, bei über 30% wird er neu erstellt*/



create index lstadt_ind on lieferant(lstadt) with (fillfactor = 85, pad_index = on);


---Indizes deaktivieren und aktivieren

--deaktivieren:

alter index lnr_ind on lieferung disable;

--aktivieren:

alter index lnr_ind on lieferung rebuild;


--Fragmentierungsgrad vom Index feststellen:

-- mit einer dynamischen Verwaltungsfunktion

select * from 
	sys.dm_db_index_physical_stats(db_id(), object_id('lieferung'), null,null,null);

-- es werden alle indizes der angegebenen Tabelle angezeigt.

-- Wenn Sie einen speziellen Index abfragen wollen benötigen Sie dei ID des indexes:

select * from sys.indexes where object_id = object_id('lieferung');

-- Jetzt wollen wir uns den Fragmentierungsgrad von lnr_ind anzeigen lassen:

select * from 
	sys.dm_db_index_physical_stats(db_id(), object_id('lieferung'), 3,null,null);




































