<?php
include_once("dbconnect.php");

// Retrieve POST data
$dryId = $_POST['dry_id'];

// Update the dry appointment's status to 'cancel'
$sqlCompleteSlot = "UPDATE dry SET dry_status = 'complete' WHERE dry_id = '$dryId'";

if ($conn->query($sqlCompleteSlot) === TRUE) {
    $response = array('status' => 'success', 'message' => 'Appointment canceled successfully.');
} else {
    $response = array('status' => 'error', 'message' => 'Failed to cancel appointment. Please try again.');
}

echo json_encode($response);
?>