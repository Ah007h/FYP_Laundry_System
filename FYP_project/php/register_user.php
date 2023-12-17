<?php
  if (!isset($_POST['register'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
  }
include_once("dbconnect.php"); 
$email = $_POST['email'];
$name = $_POST['name'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

$sqlregister = "INSERT INTO `tbl_user`(`user_email`, `user_name`,`user_phone`,`user_password`) 
VALUES ('$email','$name','$phone','$password')";

try{
if ($conn->query($sqlregister) === TRUE) {
  $response = array('status' => 'success', 'data' => null);
  sendJsonResponse($response);
  }else{
  $response = array('status' => 'failed', 'data' => null);
      sendJsonResponse($response);
  }

}catch(Exception $e) {
  $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

  $conn->close();

  function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>