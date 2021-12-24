<?php
//Connect to the database
  $server = "localhost";
  $username = "root";
  $password = "";
  $db = "cab_sharing_system";

  $con = mysqli_connect($server, $username, $password, $db);

  if(!$con)
  {
    die("connection to this database failed due to" . mysqli_connect_error());
  }

 ?>
