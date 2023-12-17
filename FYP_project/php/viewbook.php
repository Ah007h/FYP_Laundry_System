<?php
include_once("dbconnect.php");

// Create a connection to the database
$conn = new mysqli($servername, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the user_id from the request parameters
$user_id = $_GET['user_id'];

// Your SQL query to fetch appointments for a specific user
$sql = "SELECT `slot_id`, `user_id`, `slot_time`, `slot_status`, `slot_date`, `appointment_type_wash` FROM `slots` WHERE `user_id` = '$user_id'";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Initialize an array to hold the appointments
    $appointments = array();

    while ($row = $result->fetch_assoc()) {
        $appointment = array(
            'slot_id' => $row['slot_id'],
            'user_id' => $row['user_id'],
            'slot_time' => $row['slot_time'],
            'slot_status' => $row['slot_status'],
            'slot_date' => $row['slot_date'],
            'appointmentTypeWash' => $row['appointment_type_wash']
        );

        $appointments[] = $appointment;
    }

    // Return the appointments as a JSON array
    echo json_encode($appointments);
} else {
    echo "No data found for user with ID: $user_id";
}

// Close the database connection
$conn->close();
?>
