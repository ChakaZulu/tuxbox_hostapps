<?php

// Anzeigen und Eintragen in einen Terminkalender, schreibt den csv neu nach jedem Eintrag


// (Post-) Variablen abfangen php >4.1, wenn Globals off:
// -----------------------------------------------------
if ($_POST["submit"])  $submit =$_POST["submit"];
if ($_POST["export"])  $export =$_POST["export"];
if ($_POST["type"])    $type   =$_POST["type"];
if ($_POST["date"])    $date   =$_POST["date"];
if ($_POST["subject"]) $subject=$_POST["subject"];

if ($_SERVER["PHP_SELF"]) $self=$_SERVER["PHP_SELF"];
// ---------------------------------------------------


include ("tuxcal.conf.php");


// Daten aus Datenbank fischen, 3 Spalten in $tabelle stopfen:

$db = mysql_pconnect($sql_server, $sql_user, $sql_password);
mysql_select_db($sql_db,$db);
$result = mysql_query("SELECT * FROM $sql_table order by datum",$db);

$max=0;
while ($myrow = mysql_fetch_row($result))
{ for ($i=0; $i<3; $i++) { $tabelle[$max][$i]=$myrow[$i]; }
  $max++;
}

// Verarbeitung:
// $submit: neuer Eintrag, $export: CSV-Download, wenn nix, dann Darstellung

$reply="";

if ($export) { start_download($tabelle); }

else if ($submit)
{ $db=mysql_pconnect($sql_server, $sql_user, $sql_password);
  if ($db) { mysql_select_db($sql_db,$db); } else { $reply="kein Connect zur Datenbank bekommen!<br>\n"; }    

  $sql="INSERT INTO tuxcal (typ,datum,betreff) VALUES ('$type','$date','$subject')";
  $result=mysql_query($sql);
  
  if ($result) 
  { $reply="Thank you! Information entered.<br>";
    $max=count($tabelle);
    $tabelle[$max][0]=$type;
    $tabelle[$max][1]=$date;
    $tabelle[$max][2]=$subject;
  }
  else 
  { $err=mysql_error();
    $reply="Der Eintrag konnte nicht gespeichert werden!<br> SQL-Error: ".$err."<br>";
  }
}

if (!$export) 
{ output_header($reply); 
  output_tabelle($tabelle);
  output_formeingabe();
  output_formexport();
  output_footer();
}

// ===============================================================================================

function output_header($reply)
{ echo <<<OUT

<html>
<body>
<h2 style="text-align:center; text-decoration:underline">DBox II Calender (TuxCal)</h2>
<p>Status: $reply </p>
OUT;

}

function output_footer()
{ echo <<<OUT

</body>
</html>

OUT;

}

 
function output_tabelle($tabelle)
{ $max=count($tabelle);
  echo "$max Datensätze gelesen<br><table border=1 align=center> \n";
  echo "<tr><td><b>Type</b></td><td><b>Date</b></td><td><b>Subject</b></td></tr>\n";
  for ($i=0; $i<$max; $i++)
  { printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n",$tabelle[$i][0], $tabelle[$i][1], $tabelle[$i][2]);
  }
  echo "</table>\n";
}


function output_formeingabe()
{ echo <<<OUT
 
  <div align=center>
  <form method="post" action="$self">
  <table border="1">
  <tr><td><input type="Text" name="type"></td>
      <td><input type="Text" name="date"></td>
      <td><input type="Text" name="subject"></td></tr>
  </table> 
  <input type="Submit" name="submit" value="Add new entry:">
  </form>

OUT;
}


function output_formexport()
{ echo <<<OUT
 
  <form method="post" action="$self">
  <input type="hidden" name="to_csv" value="1">
  <input type="Submit" name="export" value="Export">
  </form>

  </div> 

OUT;

}

// -----------------------------------------------------------------------------------------------------

function start_download($feld)
{ header("Content-Type: application/octet-stream");
  header("Content-Disposition: attachment; filename=tuxcal.csv"); 

  $max=count($feld);
  for ($i=0; $i<$max; $i++)
  { $textzeile=$feld[$i][0].";".$feld[$i][1].";".$feld[$i][2];
    echo "$textzeile ;\n";
  }
}


?>
