<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$conn = new mysqli('localhost', 'root', '', 'ubook');

// Verificar la conexión
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}


$userId = $_POST['userId'];

$sql = "SELECT * FROM ChatList WHERE userId = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $userId);

$stmt->execute();
$result = $stmt->get_result();
$chatList = [];

while ($row = $result->fetch_assoc()) {
    $chatList[] = $row;
}

echo json_encode($chatList);

$stmt->close();
$conn->close();
?>