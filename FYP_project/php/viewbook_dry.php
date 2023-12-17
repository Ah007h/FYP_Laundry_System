<?php

// Include your database connection file
include_once("dbconnect.php");

// Create a connection to the database
$conn = new mysqli($servername, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the user_id from the request parameters
$user_id = $_GET['user_id'];

// Your SQL query to fetch dry appointments for a specific user
$sql = "SELECT `dry_id`, `user_id`, `dry_time`, `dry_status`, `dry_date`, `appointment_type` FROM `dry` WHERE `user_id` = '$user_id'";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Initialize an array to hold the dry appointments
    $dryAppointments = array();

    while ($row = $result->fetch_assoc()) {
        $dryAppointment = array(
            'dry_id' => $row['dry_id'],
            'user_id' => $row['user_id'],
            'dry_time' => $row['dry_time'],
            'dry_status' => $row['dry_status'],
            'dry_date' => $row['dry_date'],
            'appointment_type' => $row['appointment_type']
        );

        $dryAppointments[] = $dryAppointment;
    }

    // Return the dry appointments as a JSON array
    echo json_encode($dryAppointments);
} else {
    echo "No dry appointments found for user with ID: $user_id";
}

// Close the database connection
$conn->close();
?>
