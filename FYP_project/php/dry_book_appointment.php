<?php
include_once("dbconnect.php");

// Retrieve POST data
$date = $_POST['date'];
$time = $_POST['time'];
$user_id = $_POST['user_id']; // Retrieve user_id from the POST request
$appointment_type = $_POST['appointment_type']; // Retrieve appointment_type from the POST request

// Check if the selected slot is available
$sqlCheckSlot = "SELECT * FROM dry WHERE dry_date = '$date' AND dry_time = '$time'";

$resultCheckSlot = $conn->query($sqlCheckSlot);

if ($resultCheckSlot->num_rows > 0) {
    // Slot is already booked, return an error message
    $response = array('status' => 'error', 'message' => 'The selected dry is already booked.');
} else {
    // Slot is available, proceed with the booking
    $sqlBookSlot = "INSERT INTO dry (user_id, dry_time, dry_status, dry_date, appointment_type) VALUES ('$user_id', '$time', 'upcoming', '$date', '$appointment_type')";

    if ($conn->query($sqlBookSlot) === TRUE) {
        $response = array('status' => 'success', 'message' => 'Appointment booked successfully.');

        // Retrieve updated slots with appointment_type
        $sqlLoadSlots = "SELECT `dry_id`, `user_id`, `dry_time`, `dry_status`, `dry_date`, `appointment_type` FROM `dry` WHERE 1";
        $resultLoadSlots = $conn->query($sqlLoadSlots);

        if ($resultLoadSlots->num_rows > 0) {
            $slotsArray = array();
            while ($row = $resultLoadSlots->fetch_assoc()) {
                $slotsArray[] = $row;
            }
            $response['dry'] = $slotsArray;
        } else {
            $response['dry'] = array(); // No slots found
        }
    } else {
        $response = array('status' => 'error', 'message' => 'Failed to book appointment. Please try again.');
    }
}

echo json_encode($response);
?>
