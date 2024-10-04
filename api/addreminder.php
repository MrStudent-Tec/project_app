<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include 'db.php';

$user_id = $_POST['user_id'];
$reminder_message = $_POST['reminder_message'];
$reminder_date = $_POST['reminder_date'];

$query = "INSERT INTO calendar (user_id, reminder_message, reminder_date) VALUES ('$user_id', '$reminder_message', '$reminder_date')";
if (mysqli_query($conn, $query)) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error']);
}
?>