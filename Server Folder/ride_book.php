<?php
session_start();
include("connection.php");
include("functions.php");

$student_data = check_login($con);

if($_SERVER['REQUEST_METHOD'] == "POST")
{
  $source = $_POST['source'];
  $destination = $_POST['destination'];
  $date = $_POST['date'];
  $time = $_POST['time'];
  $cab_service = $_POST['cab_service'];
  $carpool = $_POST['carpool'];

  if(!empty($source) && !empty($destination) && !empty($date) && !empty($time) && !empty($cab_service) && !empty($carpool))
  {
    $reg_no = $_SESSION['reg_no'];
    if($carpool == 'yes')
    {
      $cpool = 1;
    }
    else
    {
      $cpool = 0;
    }
    $query = "INSERT INTO ride_booked(source, destination, date_booked, time_booked, desired_cab_service, want_carpooling, reg_no) VALUES ('$source', '$destination', '$date', '$time', '$cab_service', '$cpool', '$reg_no')";

    mysqli_query($con, $query);
    #echo mysqli_error($con);
    header("Location: homepage.php");
    die;
  }
  else
  {
    echo "All fields are compulsory";
  }
}
 ?>

<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Book a Ride</title>
    <link rel="stylesheet" href="styles.css">
  </head>
  <body>
    <h1>Cab Sharing System</h1>
    <div class="text_body">
    <form method="post" action="ride_book.php">
      <label for="source">Source</label><br>
      <input type="text" name="source"><br>
      <label for="destination">Destination</label><br>
      <input type="text" name="destination"><br>
      <label for="date">Date for Ride</label><br>
      <input type="date" name="date"><br>
      <label for="time">Time</label><br>
      <input type="time" name="time"><br>
      <label for="cab_service">Desired Cab Service</label><br>
      <input type="text" name="cab_service"><br>
      Do you want carpooling?
      <input type="radio" name="carpool" value="yes">
      <label for="yes">Yes</label>
      <input type="radio" name="carpool" value="no">
      <label for="no">No</label><br>
      <input type="submit" value="Submit">
    </form>
    </div>
  </body>
</html>
