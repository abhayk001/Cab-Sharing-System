<?php
session_start();
include("connection.php");
include("functions.php");
$student_data = check_login($con);
 ?>

<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Home Page</title>
    <link rel="stylesheet" href="styles.css">
  </head>
  <body>
    <h1>Cab Sharing System</h1>
    <a href="/ride_book.php">
      <button class="button leftbutton">Book a Ride</button>
    </a>
    <a href="/rides.php">
      <button class="button centerbutton">Check your Rides</button>
    </a>
    <a href="/login.php?option=logout">
      <button class="button rightbutton">Logout</button>
    </a>
  </body>
</html>
