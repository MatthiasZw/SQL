dbcc checkdb('standard');  ----------------Integrit�tscheck, reparatur von seiten


select * from msdb.dbo.suspect_pages;     --- besch�digte seiten, ab 1000 fehler bleibt datenbank stehen


/*Denken Sie dar�ber nach, wie ich die Datens�tze einer Tabelle oder einer
Abfrage in eine Datei name.txt im Verzeichnis c:\dokumente bekomme. */