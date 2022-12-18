<head>
  <title>Drivers who have Won a Race</title>
 </head>
 <body>
 
 <?php
// PHP code just started

ini_set('error_reporting', E_ALL);
ini_set('display_errors', true);
// display errors

$db = mysqli_connect("dbase.cs.jhu.edu", "22fa_szhan141", "TvW17CsQSB");
// ********* Remember to use your MySQL username and password here ********* //

if (!$db) {
  echo "Connection failed!";

} else {
  mysqli_select_db($db, "22fa_szhan141_db");
  // ********* Remember to use the name of your database here ********* //

  $result = mysqli_query($db, "CALL Q5()");
  // call to procedure

  if (!$result || $result->num_rows == 0) {
    echo "No results.\n";

  } else {
    // call to procedure
    echo "<table border=1>\n";
    echo "<tr><td>FirstName</td><td>LastName</td></tr>\n";
    while ($myrow = mysqli_fetch_array($result)) {
      printf("<tr><td>%s</td><td>%s</td></tr>\n", 
        $myrow["fname"], $myrow["lname"]);
    }
    echo "</table>\n";
  }
}

// PHP code about to end

?>

</body>

