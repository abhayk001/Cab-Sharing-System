<?php
//Start the session. This persists till disconnection
session_start();
include("connection.php");
include("functions.php");

if(isset($_GET['option']) && $_GET['option'] == "logout")
{
  unset($_SESSION['reg_no']);
}
echo "<div class='text_body'>";
if($_SERVER['REQUEST_METHOD'] == "POST")
{
  //something was posted in the form
  $reg_no = $_POST['regno'];
  $password = sha1($_POST['password']);

  //If nothing is missing
  if(!empty($reg_no) && !empty($password))
  {
    //search the database
    $query = "SELECT * FROM student WHERE reg_no = '$reg_no' LIMIT 1";
    $result = mysqli_query($con, $query);

    if($result && mysqli_num_rows($result) > 0)
    {
      $student_data = mysqli_fetch_assoc($result);

      if($student_data['password'] === $password)
      {
        $_SESSION['reg_no'] = $reg_no;
        header("Location: homepage.php");
        die;
      }
    }
    echo "Register number or password is incorrect";
  }

  else
  {
    echo "All fields are compulsory";
  }
}
echo "</div>";
 ?>

<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Login</title>
    <link rel="stylesheet" href="styles.css">
  </head>
  <body>
    <h1>Cab Sharing System</h1>
    <div class="text_body">
    <form method="post">
      <label for="regno">Register Number</label><br>
      <input type="text" name="regno"><br>
      <label for="password">Password</label><br>
      <input type="password" name="password"><br><br>
      <input type="submit" value="Submit">
    </form>
    <br>
    New here?
    <a href="/register.php">
      <button class="smallbutton">Register Here!</button>
    </a>
    </div>
  </body>
</html>
