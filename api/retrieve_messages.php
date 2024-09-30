<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$conn = new mysqli('localhost', 'root', '', 'ubook');

// Verificar la conexión
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}


$senderId = $_GET['senderId'];
$receiverId = $_GET['receiverId'];

$sql = "SELECT * FROM chats WHERE (sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?) ORDER BY id ASC";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssss", $senderId, $receiverId, $receiverId, $senderId);
$stmt->execute();
$result = $stmt->get_result();

$chats = array();
while ($row = $result->fetch_assoc()) {
    $chats[] = $row;
}

echo json_encode($chats);

$stmt->close();
$conn->close();
?>