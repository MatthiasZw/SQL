dbcc checkdb('standard');  ----------------Integritätscheck, reparatur von seiten


select * from msdb.dbo.suspect_pages;     --- beschädigte seiten, ab 1000 fehler bleibt datenbank stehen


/*Denken Sie darüber nach, wie ich die Datensätze einer Tabelle oder einer
Abfrage in eine Datei name.txt im Verzeichnis c:\dokumente bekomme. */