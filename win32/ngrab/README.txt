-----------------------------------------------------------------------------------------------------------------------------
 NGrab CVS 
 Installation der Entwicklungsumgebung

 Erstellt: 16.11.2003 von Michael Sommer (TGLynx)

 Ge�ndert:
-----------------------------------------------------------------------------------------------------------------------------

Schritt 1:
Vorraussetzungen:
Zur Entwicklung von NGrab ben�tigt Ihr Visual Basic 6.0 Service Pack 5 (oder Visual Studio 6.0 Service Pack 5).
Damit k�nnt Ihr die NGrab Sourcen vern�nftig editieren, debuggen und kompilieren.

Ausserdem ist eine Installation der aktuellen Version von NGrab Vorraussetzung.
Diese wird wegen der Komponenten ben�tigt die in NGrab verwendet werden. Die NGRab Setuproutine liefert alle 
ben�tigten Komponenten in den entsprechenden Versionen mit.

Schritt 2:
Setzen der bin�rkompatiblen Komponente f�r die NGrab Engine. Dieser Schritt ist wichtig! ;)
Damit die NGRab Engine zur kompilierten Version bin�rkompatibel bleibt muss im NGRabEngine Projekt eine
bin�rkompatible Komponente angegeben werden. 
Das ist notwendig da das Interface dieser Bibliothek per 'early binding' direkt in das Frontend kompiliert ist.

1. �ffnen des NGrabEngine10.vbp Visual Basic Projektes
2. Unter Projekt/Eigenschaften => Komponente die vom NGrab Setup installierte Version der NGrabEngine10.dll angeben.
Diese befindet sich normalerweise unter C:\Programme\Gemeinsame Dateien\NGrab\ (aber da bin ich mir nicht ganz sicher ;))
Im Zweifelsfall mal eben nach NGrabEngine10.dll suchen ;)
3. Mit OK best�tigen
4. Projekt speichern

Schritt 3:
Fertig ;)

Um nun das Frontend zusammen mit der NGrabEngine zu debuggen wird einfach zuerst das NGRabEngine10.vbp Projekt 
ge�ffnet und per STRG+F5 gestartet und dann das NGrab.vbp Projekt.

Bei der Entwicklung sollte darauf geachtet werden die so genannte Hungarian Notation einzuhalten. So wie ich mich 
kenne werde ich nicht eher ruhen bis auch die letzte Zeile Source Code in NGrab so aussieht das sie mir gef�llt ;)
(Das ist noch nicht der Fall) ;)

Viel Spass damit w�nschen
Flagg, ZeroQ, TGLynx
