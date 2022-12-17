<head>
  <title>Average number of accidents in each circuit</title>
 </head>
 <body>
 
 <?php
// PHP code just started
$dataPoints = array();
$show = true;
ini_set('error_reporting', E_ALL);
ini_set('display_errors', true);
// display errors

$db = mysqli_connect("dbase.cs.jhu.edu", "22fa_szhan141", "TvW17CsQSB");
// ********* Remember to use your MySQL username and password here ********* //

if (!$db) {
  echo "Connection failed!";

} else {
  // This says that the $ID variable should be assigned a value obtained as an
  // input to the PHP code. In this case, the input is called 'ID'.

  mysqli_select_db($db, "22fa_szhan141_db");
  // ********* Remember to use the name of your database here ********* //

  $result = mysqli_query($db, "CALL ShowAverageAccidentsInCircuit()");
  if (!$result || $result->num_rows == 0) {
    echo "No results.\n";
  } else {
    // call to procedure
    echo "<table border=1>\n";
    echo "<tr><td>Name</td><td>Location</td><td>Average number of accidents</td></tr>\n";
    $not_done = 0;
    while ($myrow = mysqli_fetch_array($result)) {
      printf("<tr><td>%s</td><td>%s</td><td>%.2f</td></tr>\n", 
        $myrow["name"], $myrow["location"], $myrow["AvgNumAccident"]);
        if ($not_done < 10) {
        array_push($dataPoints, array("label"=> $myrow["name"], "y"=> $myrow["AvgNumAccident"]));
        }
      $not_done++;
    }

    echo "</table>\n";
  }
}

// PHP code about to end

?>
<html>
  <head>
	<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script> 
    <title> Rank countries by number of circuits </title>
    <script>
      var show =<?php echo json_encode($show); ?>;
      window.onload = function () {
        var chart = new CanvasJS.Chart("chartContainer", {
          animationEnabled: true,
          exportEnabled: true,
          theme: "light1", // "light1", "light2", "dark1", "dark2"
          title: {
            text: "Number of circuits in each country"
          },
          data: [{
            type: "column",
            dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
          }]
        });
        if (show) chart.render();
      }
    </script>
  </head>
  <body>
    <div id="chartContainer" style="height: 400px; width:100%;"></div>   
  </body>
</html>
 </body>