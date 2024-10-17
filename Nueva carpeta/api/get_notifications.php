<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db.php';  // Asegúrate de incluir tu conexión a la base de datos

$user_id = $_GET['user_id']; // Asumiendo que pasas el ID del usuario en la URL

$sql = "SELECT title, message, is_read FROM notifications WHERE user_id = '$user_id' ORDER BY created_at DESC";
$result = $conn->query($sql);

$notifications = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $notifications[] = $row;
    }
}

echo json_encode($notifications);
$conn->close();
?>
