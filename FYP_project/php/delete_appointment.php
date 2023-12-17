<?php
include_once("dbconnect.php");

// Retrieve POST data
$slotId = $_POST['slot_id'];

// Delete the appointment
$sqlDeleteSlot = "DELETE FROM slots WHERE slot_id = '$slotId'";

if ($conn->query($sqlDeleteSlot) === TRUE) {
    $response = array('status' => 'success', 'message' => 'Appointment deleted successfully.');
} else {
    $response = array('status' => 'error', 'message' => 'Failed to delete appointment. Please try again.');
}

echo json_encode($response);
?>
