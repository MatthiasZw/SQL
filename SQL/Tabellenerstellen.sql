use standard;
go

--INto- Klausel

-- Damit kann das Ergebnis einer Abfrage in eine neue permanente oder tempor�re Tabelle gespeichert werden


-- permanente Tabellen
-- D�rfen nur USer mit der Berechtigung "create table", "alter any schema", oder 
-- Mitglieder der Datenbankrolle db_ddladmin oder db_owner oder MItglieder der Serverrolle sysadmin

select anr, aname, farbe
into rote_artikel from artikel where farbe = 'rot';

select * from rote_artikel;

--------------------------------------------------------------------------------

-- Tempor�re Tabellen

-- lokale tempor�re Tabellen

--Namen: #tabellenname

--sind nur f�r die Sitzung g�ltig die diese Tabellen erzeugt hat, ist die Sitzung vorbei  existieren auch diese Tabellen nicht mehr

select anr, aname, farbe
into #rote_artikel from artikel where farbe = 'rot';

select * from #rote_artikel


-- globale tempor�re Tabellen

--Namen: ##tabellenname

--sind nur f�r alle laufenden Sitzung g�ltig, ist die Sitzung vorbei die erstellt hat existieren auch diese Tabellen nicht mehr


select anr, aname, farbe
into ##rote_artikel from artikel where farbe = 'rot';

select * from ##rote_artikel


--Addition von Mengen
-- zwischen beiden Mengen muss UNION-Kompatibilit�t existieren, d.h. gleiche ANzahl von Spalten
	-- und Datentypen der zu addierenden Spalten muss �bereinstimmen

	-- Union eliminiert automatisch doppelte Datens�tze im Ergebnis

--Alle Orte in denen Lieferanten wohnen oder in denen Artikel lagern

select lstadt from lieferant
	union
	select astadt from artikel;


-- alle Datens�tze des Ergebnis anzeigen 

select lstadt from lieferant
	union all
	select astadt from artikel;


	select lstadt as [Orte] from lieferant
	union
	select astadt from artikel;

-- Minus mit EXCEPT

-- Gesucht sind alle Wohnorte von Lieferanten an denen keine Artikel gelagert sind

select lstadt as [Orte] from lieferant
	except
	select astadt from artikel;

	delete lieferant where lnr > 'L05'

--Schnittmenge mit INTERSECT

-- gesucht sind alle orte wo sowohl Lieferanten wohnen als auch artikel lagern (unredundanziert)

select lstadt as [Orte] from lieferant
	intersect
	select astadt from artikel;






	