<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$conn = new mysqli('localhost', 'root', '', 'ubook');

// Verificar la conexión
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

$user_id = $_POST['user_id'];

// Corrección: El nombre correcto de la tabla es 'chatlist' (en minúsculas)
$sql = "SELECT * FROM chatlist WHERE user_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $user_id);

$stmt->execute();
$result = $stmt->get_result();
$chatlist = [];

while ($row = $result->fetch_assoc()) {
    $chatlist[] = $row;
}

echo json_encode($chatlist);

$stmt->close();
$conn->close();
?>
