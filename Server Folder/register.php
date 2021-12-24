<?php
  session_start();
  include("connection.php");
  include("functions.php");

  echo "<div class='text_body'>";

  if($_SERVER['REQUEST_METHOD'] == "POST")
  {
    //something was posted in the form
    $reg_no = $_POST['regno'];
    $name = $_POST['name'];
    $phno = $_POST['phno'];
    $password = sha1($_POST['password']);

    //If nothing is missing
    if(!empty($reg_no) && !empty($name) && !empty($phno) && !empty($password))
    {
      //save to database
      $query = "INSERT INTO student (reg_no, name, phno, password) VALUES ('$reg_no', '$name', '$phno', '$password')";
      mysqli_query($con, $query);
      header("Location: login.php");
      die;
    }

    else
    {
      echo "All fields are compulsory";
    }
  }
  echo "<div>";
 ?>

<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Register</title>
    <link rel="stylesheet" href="styles.css">
  </head>
  <body>
    <h1>Cab Sharing System</h1>
    <div class="text_body">
    <form method="post">
      <label for="regno">Register Number</label><br>
      <input type="text" name="regno"><br>
      <label for="name">Name</label><br>
      <input type="text" name="name"><br>
      <label for="phno">Phone Number</label><br>
      <input type="text" name="phno"><br>
      <label for="password">Password</label><br>
      <input type="password" name="password"><br><br>
      <input type="submit" value="Submit">
    </form>
    </div>
  </body>
</html>
