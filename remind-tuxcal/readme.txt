Kurzdokumentation zur Reminder Shell:

Autor:		stikx
Datum:		28.05.2003
Version:	0.4
Dank:		an terrae für das Kalender Plugin und die tolle Zusammenarbeit
		an masite für die unermüdliche Ideenlieferung und das Testen
		an Ulli010 für die Pionierarbeit Dream/Enigma und das Testen
		und speziell Regloh für alles halt.


Funktionsbeschreibung:
Diese Shell klingt sich in das Startup des Neutrino oder Enigma der Tuxbox sowie Dreambox.
Sie wird in den Hintergrund geladen und erstmal schlafen gelegt bis alles andere gestartet ist.
Wenn Sie wirksam wird, durchsucht die Shell die Datei /var/tuxbox/config/tuxcal/tuxcal.list
nach Geburtstagseinträgen mit aktuellem Datum (heute) und Datum plus einen Tag (morgen).
Diese Einträge werden dann in einem Fenster am TV angezeigt, solange bis diese mit 
OK an der Fernbedienung bestätigt sind, oder nach einem Timeout weggeblendet werden.
Bei zusätzlichem Eintrag des Geburtsdatums wird das Alter zum Namen eingeblendet.
Die Ausgabe ist auf 6 Geburtstage pro Tag beschränkt. Es können mehr Einträge in der DB
vorhanden sein, diese werden jedoch ignoriert (Prinzip: First come, first serve). 
Die Shell erkennt den Boxtyp bzw. die GUI automatisch, schlägt das fehl (warum auch immer!)
kann die Shell mit den Parametern –n/e aufgerufen werden um den Type vorzugeben.

-n = Neutrino
-e = Enigma auf Tuxbox oder Dreambox

GUI: 		Neutrino
		Enigma

Boxtyp:	Tuxbox (Dbox2)
		Dreambox

DB Format:
Das Format der Datei /var/tuxbox/config/tuxcal/tuxcal.list muss wie nachfolgend aufgebaut sein:
Ein Match im Satz erfolgt auf g;xx.yy.zzzz;Vorname Nachname;
wobei xx für Tag und yy für Monat sowie zzzz für das Geburtsjahr steht  
Beispiel: 	g;14.06.1968;Chris Wagner;
		g;23.09.;Jesse James;
Wie aus dem Beispiel zu ersehen ist, wird das Geburtsjahr im normalen Datumsformat eingegeben.
Ist das Geburtsjahr nicht bekannt, wird es einfach weggelassen (siehe Beispiel Record 2).
Nach dem Semikolon am Ende des Records darf kein Leer- oder sonstiges Zeichen vorkommen
da sonst die Ausgabe falsch formatiert würde. Semikolon als Limiter ist zwingend.
Eine Basisdatei ist im Download als Beispiel enthalten. Bitte nur benutzen als Template
und wenn nicht schon vorhanden!
Das Format dieser Datei und der Standort ist synchron mit terrae’s Tuxcal v. 0.4 und läuft
mit terrae’s Kalender als auch Standalone. (Kann mit Editor oder einem Remote Frontend 
[sind in Arbeit z.B. von masite]  bearbeitet werden).
ACHTUNG: Das Format hat sich von 0.3 auf 0.4 minimal geändert! Die Datei heißt jetzt 
tuxcal.list und befindet sich im Verzeichnis /var/tuxbox/config/tuxcal


Aufruf Parameter / Standort:
reminder liegt jetzt unter /var/tuxbox/config/tuxcal. Sollte das Verzeichnis nicht existieren,
so muss es angelegt werden. Zum Test kann reminder über Telnet manuell gestartet werden.
Aufruf erfolgt mit “sh reminder“ und optional den Parametern –h oder –ns, wobei –h für Hilfe steht
und –ns für no sleep. Letzteres verhindert die verzögerte Ausführung (30 Sekunden).
Ebenfalls kann mit den Parametern –n/e die Gui bzw. der Boxtyp vorgegeben werden.


Installation: 
Nach Download und unzip die Datei reminder per ftp ins Verzeichnis /var/tuxbox/config/tuxcal
hochladen. Wenn tuxcal nicht vorhanden ist, mit mkdir tuxcal in der ftp session im Verzeichnis
/var/tuxbox/config anlegen. Wenn reminder hochgeladen ist,  telnet session auf die Dbox starten
und ins Verzeichnis /var/tuxbox/config/tuxcal mit cd tuxbox/config/tuxcal wechseln
und den Befehl chmod 755 reminder ausführen. Der Befehl ls -l reminder sollte dann –rwxr-xr-x
als permissions bei reminder ausgeben. Anschließend die Datei tuxcal.list bei Bedarf per ftp
ins Verzeichnis /var/tuxbox/config/tuxcal hochladen (Nur wenn nicht schon vorhanden).
Das ist auch nicht notwendig, wenn bereits tuxcal als Plugin installiert ist.
Anschließend bzw. vorher die Datei nach euren Wünschen bearbeiten.


Es folgt der kritische Teil der Installation. 
Wählt bitte die richtige Methode (1, 2, 3) , Gui und Box aus.
Da auch verschiedene Cramfs unterschiedliche Startshell haben,
kann das bei dem ein oder anderen ein wenig von meiner Version abweichen.

1. Anpassen Startup Neutrino/Tuxbox:
Dazu eine Telnet Session auf die Box starten und ins Verzeichnis tuxbox wechseln. 
Dort sind drei Links auf die Dateien start_neutrino, start_enigma  und start_lcars gesetzt.
Mit dem Befehl rm start_neutrino wird der link gelöscht. Anschließend sofort den Befehl
cp /etc/init.d/start_neutrino start_neutrino aufrufen um eine neue Datei zu erstellen.
Dann wird die neue Datei editiert, mit welchem Tool auch immer (z.B. vi ).
In der nächsten (neuen) Zeile hinter /bin/cdkvcinfo Neutrino wird der Aufruf 
/bin/sh /var/tuxbox/config/tuxcal/reminder & eingetragen. 
Wichtig: Das & nicht vergessen. Speichern und fertig.

2. Anpassen Startup Enigma/Tuxbox:
Dazu eine Telnet Session auf die Box starten und ins Verzeichnis tuxbox wechseln.
Dort sind drei Links auf die Dateien start_neutrino, start_enigma  und start_lcars gesetzt.
Mit dem Befehl rm start_enigma wird der link gelöscht. Anschließend sofort den Befehl
cp /etc/init.d/start_enigma start_enigma aufrufen um eine neue Datei zu erstellen.
Dann wird die neue Datei editiert, mit welchem Tool auch immer (z.B. vi ).
In der nächsten (neuen) Zeile hinter /bin/cdkvcinfo –novc Enigma wird der Aufruf
/bin/sh /var/tuxbox/config/tuxcal/reminder & vor der Zeile /bin/camd2 eingetragen.
Wichtig: Das & nicht vergessen. Speichern und fertig.

3. Anpassen Startup Enigma/Dreambox:
Dazu eine Telnet Session auf die Box starten und ins Verzeichnis tuxbox wechseln.
Dort fndet Ihr die Datei start_enigma,  die editiert werden muss, mit welchem Tool 
auch immer (z.B. vi ). In der nächsten (neuen) Zeile hinter fi und noch vor 
/bin/initkeys wird der Aufruf /bin/sh /var/tuxbox/config/tuxcal/reminder & eingetragen.
Wichtig: Das & nicht vergessen. Speichern und fertig.


Testen:
Wenn ihr die Installation durchgeführt habt solltet Ihr zuerst die Funktion manuell testen.
Dazu eine Telnet Session auf der Box aufrufen und ins Verzeichnis /var/tuxbox/config/tuxcal wechseln.
Jetzt sh reminder –ns aufrufen. Wenn ein aktueller Geburtstag heute oder morgen
in der tuxcal.conf eingetragen ist, wird das auf dem TV ausgegeben.
Eventuell werden auch Fehlermeldungen ausgegeben (z.B. Datei fehlt).  


Abhängigkeiten:
Neutrino http API
Enigma http API (Ausgabe und Datum query)
Tuxcal Plugin (oder Standalone File)

Dateien:
reminder		Shell
tuxcal.list		DB Datei (Beispiel)
readme.txt		diese Datei
KurzDokuRS.pdf		Doku als PDF

Änderungen:
v. 0.4		- Enigma auf Tuxbox und Dreambox supportet
		- neue Startparameter
		- Ausgabe des Alters bei Eintrag von Geburtsdatum
 		- Korrektur Ausgabe bei Mehrfacheinträgen an einem Tag
		- Ausgabe am TV leicht umformatiert
		- Standort des Reminders jetzt im neuen Verzeichnis
		  /var/tuxbox/config/tuxcal
		- DB Datei heißt jetzt tuxcal.list und liegt auch im Verzeichnis
		  /var/tuxbox/config/tuxcal
		- DB Datei leicht geändert – Hinzufügen von Geburtsdatum und
		  Wegfall des Strings “Geburtstag: “ beim Namen
		- Dokumentation jetzt im PDF Format
v. 0.3 		– Format der tuxcal.conf geändert
		- Ausgabe jetzt mit Datum
		- Version synchron mit tuxcal
v. 0.2 		– nicht released
v. 0.1 		– erstes release 

Bekannte Beschränkungen:
Ausgabe von 6 Geburtstagen pro Tag (first come, first serve)
Enigma Datum nur über http query (date liefert falsches Datum)
Record Format ist zwingend, falsche Formatierung wird nicht korrigiert
Ultralange Namen führen zu unkorrekter Darstellung vor allem bei Neutrino


Weitere Beschreibung im Header bzw. im Ablauf der eigentlichen Shell

Viel Spass und Erfolg
stikx
