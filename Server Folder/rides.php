<?php
session_start();
include("connection.php");
include("functions.php");

$student_data = check_login($con);

$rno = $_SESSION['reg_no'];
$query = "SELECT f.ride_id AS ride_id, c.car_number_plate AS no_plate, c.driver_name AS dr_name, c.driver_phno AS dr_phno, f.date_of_ride AS ride_date, f.time_of_ride AS ride_time, f.source AS src, f.destination AS dstn, c.cab_service AS cabserv
          FROM final_ride f, cab c, passengers p
          WHERE p.ride_id = f.ride_id AND f.car_number_plate = c.car_number_plate
          AND p.reg_no = '$rno'";

echo "<h1>Cab Sharing System</h1>";
echo "<div class='text_body'>";

$result = mysqli_query($con, $query);
if($result && mysqli_num_rows($result) > 0)
{
  while($data = mysqli_fetch_assoc($result))
  {
    echo "<h3>Ride</h3>";
    echo "Ride ID: ".$data['ride_id']."<br>";
    echo "Car Number Plate: ".$data['no_plate']."<br>";
    echo "Driver's Name: ".$data['dr_name']."<br>";
    echo "Driver's Phone Number: ".$data['dr_phno']."<br>";
    echo "Cab Service: ".$data['cabserv']."<br>";
    echo "Source: ".$data['src']."<br>";
    echo "Destination: ".$data['dstn']."<br>";
    echo "Date: ".$data['ride_date']."<br>";
    echo "Time: ".$data['ride_time']."<br>";

    $rid = $data['ride_id'];
    $q2 = "SELECT reg_no FROM passengers WHERE ride_id = '$rid' AND reg_no <> '$rno'";
    $result2 = mysqli_query($con, $q2);

    if($result2 && mysqli_num_rows($result2) > 0)
    {
      echo "<h3>Carpool Partners</h3>";
      while($d = mysqli_fetch_assoc($result2))
      {
        echo "Registration Number: ".$d['reg_no']."<br>";
      }
    }
  }
}

echo "</div>";
 ?>

<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Your Rides</title>
    <link rel="stylesheet" href="styles.css">
  </head>
  <body>
  </body>
</html>
