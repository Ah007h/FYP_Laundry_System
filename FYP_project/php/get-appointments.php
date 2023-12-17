<?php
header('Content-Type: application/json');

if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $db_host = "localhost";
    $db_user = "root";
    $db_password = "";
    $db_name = "fyp_project";

    // Establish a MySQL database connection
    $conn = new mysqli($db_host, $db_user, $db_password, $db_name);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Fetch data from the database table
    $query = "SELECT * FROM tbl_book"; // Adjust the table name and columns as necessary
    $result = $conn->query($query);

    $appointments = array();

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $appointments[] = $row;
        }
        echo json_encode($appointments);
    } else {
        echo json_encode([]);
    }

    $conn->close();
} else {
    http_response_code(400);
    echo json_encode(array("error" => "Invalid request method."));
}

?>
