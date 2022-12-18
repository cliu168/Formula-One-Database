<head> 
  <title>Average Points of Constructors per Season</title>
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
  $show = false;

} else {
  mysqli_select_db($db, "22fa_szhan141_db");
  // ********* Remember to use the name of your database here ********* //

  $result = mysqli_query($db, "CALL Q11()");
  // call to procedure

  if (!$result || $result->num_rows == 0) {
    echo "No results.\n";
    $show = false;
    
  } else {
    echo "<table border=1>\n";
    echo "<tr><td>Name</td><td>Location</td><td>AveragePts</td></tr>\n";
    $not_done = 0;
    while ($myrow = mysqli_fetch_array($result)) {
        printf("<tr><td>%s</td><td>%.2f</td></tr>\n", 
        $myrow["name"], $myrow["location"], $myrow["avgPts"]);
        if ($not_done < 10) {
            $not_broken = iconv("UTF-8", "UTF-8//IGNORE", $myrow["name"]);
            array_push($dataPoints, array("label"=> $not_broken, "y"=> $myrow["avgPts"])); 
        }
        $not_done++;
    }
  }
  echo "</table>\n";
}

// PHP code about to end

?>
<html>
  <head>
  <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script> 
    <title>Average Points of Constructors per Season</title>
    <script>
      var show =<?php echo json_encode($show); ?>;
      window.onload = function () {
        var chart = new CanvasJS.Chart("chartContainer", {
          animationEnabled: true,
          exportEnabled: true,
          theme: "light1",
          title: {
            text: "Average Points of Constructors per Season"
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