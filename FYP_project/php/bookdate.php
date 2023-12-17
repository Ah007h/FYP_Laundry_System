<?php
// Connect to your database (you will need to replace these values with your actual database credentials)
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "fyp_project";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the date and time from the POST request
$date = $_POST["date"];
$time = $_POST["time"];
$status = "Pending"; // You can set the initial status as "Pending" or any other default value

// Insert the data into your database (replace 'bookings' with your actual table name)
$sql = "INSERT INTO bookings (book_date, book_time, book_status) VALUES ('$date', '$time', '$status')";

if ($conn->query($sql) === TRUE) {
    echo "Data inserted successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>