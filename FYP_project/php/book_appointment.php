<?php
include_once("dbconnect.php");

// Retrieve POST data
$date = $_POST['date'];
$time = $_POST['time'];
$user_id = $_POST['user_id'];
$appointment_type_wash = $_POST['appointment_type_wash']; // Change the variable name

$sqlCheckSlot = "SELECT * FROM slots WHERE slot_date = '$date' AND slot_time = '$time'";
$resultCheckSlot = $conn->query($sqlCheckSlot);

if ($resultCheckSlot->num_rows > 0) {
    $response = array('status' => 'error', 'message' => 'The selected slot is already booked.');
} else {
    $sqlBookSlot = "INSERT INTO slots (user_id, slot_time, slot_status, slot_date, appointment_type_wash) VALUES ('$user_id', '$time', 'upcoming', '$date', '$appointment_type_wash')";

    if ($conn->query($sqlBookSlot) === TRUE) {
        $response = array('status' => 'success', 'message' => 'Appointment booked successfully.');

        $sqlLoadSlots = "SELECT `slot_id`, `user_id`, `slot_time`, `slot_status`, `slot_date`, `appointment_type_wash` FROM `slots` WHERE 1";
        $resultLoadSlots = $conn->query($sqlLoadSlots);

        if ($resultLoadSlots->num_rows > 0) {
            $slotsArray = array();
            while ($row = $resultLoadSlots->fetch_assoc()) {
                $slotsArray[] = $row;
            }
            $response['slots'] = $slotsArray;
        } else {
            $response['slots'] = array(); // No slots found
        }
    } else {
        $response = array('status' => 'error', 'message' => 'Failed to book appointment. Please try again.');
    }
}

echo json_encode($response);
?>
