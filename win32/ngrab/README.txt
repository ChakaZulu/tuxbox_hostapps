-----------------------------------------------------------------------------------------------------------------------------
 NGrab CVS 
 Installation der Entwicklungsumgebung

 Erstellt: 16.11.2003 von Michael Sommer (TGLynx)

 Geändert:
-----------------------------------------------------------------------------------------------------------------------------

Schritt 1:
Vorraussetzungen:
Zur Entwicklung von NGrab benötigt Ihr Visual Basic 6.0 Service Pack 5 (oder Visual Studio 6.0 Service Pack 5).
Damit könnt Ihr die NGrab Sourcen vernünftig editieren, debuggen und kompilieren.

Ausserdem ist eine Installation der aktuellen Version von NGrab Vorraussetzung.
Diese wird wegen der Komponenten benötigt die in NGrab verwendet werden. Die NGRab Setuproutine liefert alle 
benötigten Komponenten in den entsprechenden Versionen mit.

Schritt 2:
Setzen der binärkompatiblen Komponente für die NGrab Engine. Dieser Schritt ist wichtig! ;)
Damit die NGRab Engine zur kompilierten Version binärkompatibel bleibt muss im NGRabEngine Projekt eine
binärkompatible Komponente angegeben werden. 
Das ist notwendig da das Interface dieser Bibliothek per 'early binding' direkt in das Frontend kompiliert ist.

1. Öffnen des NGrabEngine10.vbp Visual Basic Projektes
2. Unter Projekt/Eigenschaften => Komponente die vom NGrab Setup installierte Version der NGrabEngine10.dll angeben.
Diese befindet sich normalerweise unter C:\Programme\Gemeinsame Dateien\NGrab\ (aber da bin ich mir nicht ganz sicher ;))
Im Zweifelsfall mal eben nach NGrabEngine10.dll suchen ;)
3. Mit OK bestätigen
4. Projekt speichern

Schritt 3:
Fertig ;)

Um nun das Frontend zusammen mit der NGrabEngine zu debuggen wird einfach zuerst das NGRabEngine10.vbp Projekt 
geöffnet und per STRG+F5 gestartet und dann das NGrab.vbp Projekt.

Bei der Entwicklung sollte darauf geachtet werden die so genannte Hungarian Notation einzuhalten. So wie ich mich 
kenne werde ich nicht eher ruhen bis auch die letzte Zeile Source Code in NGrab so aussieht das sie mir gefällt ;)
(Das ist noch nicht der Fall) ;)

Viel Spass damit wünschen
Flagg, ZeroQ, TGLynx
