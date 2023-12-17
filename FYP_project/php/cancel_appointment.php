<?php
include_once("dbconnect.php");

// Retrieve POST data
$slotId = $_POST['slot_id'];

// Update the slot's status to 'cancel'
$sqlCancelSlot = "UPDATE slots SET slot_status = 'cancel' WHERE slot_id = '$slotId'";

if ($conn->query($sqlCancelSlot) === TRUE) {
    $response = array('status' => 'success', 'message' => 'Appointment canceled successfully.');
} else {
    $response = array('status' => 'error', 'message' => 'Failed to cancel appointment. Please try again.');
}

echo json_encode($response);
?>
