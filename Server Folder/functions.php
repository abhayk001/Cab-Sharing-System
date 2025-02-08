<?php
  function check_login($con)
  {
    //If the register number has been set in the session
    if(isset($_SESSION['reg_no']))
    {
      $id = $_SESSION['reg_no'];
      $query = "SELECT * FROM student WHERE reg_no = '$id' LIMIT 1";

      $result = mysqli_query($con, $query);

      //Positive result and more than 0 rows
      if($result && mysqli_num_rows($result) > 0)
      {
        $student_data = mysqli_fetch_assoc($result);
        return $student_data;
      }
    }

    //If it didn't work, redirect to login page
    header("Location: login.php");
    die;
  }
 ?>
