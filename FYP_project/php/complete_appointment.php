<?php
include_once("dbconnect.php");

// Retrieve POST data
$slotId = $_POST['slot_id'];

// Update the slot appointment's status to 'complete'
$sqlCompleteSlot = "UPDATE slots SET slot_status = 'complete' WHERE slot_id = '$slotId'";

if ($conn->query($sqlCompleteSlot) === TRUE) {
    $response = array('status' => 'success', 'message' => 'Appointment completed successfully.');
} else {
    $response = array('status' => 'error', 'message' => 'Failed to complete appointment. Please try again.');
}

echo json_encode($response);
?>
