<?php
// Include the database connection file
require_once 'dbconnect.php';

// Define an array to store the booked slots
$bookedSlots = array();

// Your SQL query to retrieve booked slots goes here
$sql = "SELECT `dry_id`, `user_id`, `dry_time`, `dry_status`, `dry_date`, `appointment_type` FROM `dry` WHERE 1";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        // Add each booked slot to the array
        $bookedSlots[] = $row;
    }
}

// Close the database connection
$conn->close();

// Convert the booked slots array to JSON format
$bookedSlotsJSON = json_encode($bookedSlots);

// Set the response content type to JSON
header('Content-Type: application/json');

// Return the JSON data
echo $bookedSlotsJSON;
?>
