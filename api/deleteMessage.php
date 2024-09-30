<?php
// Habilitar CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Conexión a la base de datos
$conn = new mysqli('localhost', 'root', '', 'ubook');


if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

// Manejar la solicitud POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $messageId = $_POST['messageId'];

    // Borrar el mensaje
    $sql = "DELETE FROM Chats WHERE messageId = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $messageId);

    if ($stmt->execute()) {
        echo json_encode(["success" => true]);
    } else {
        echo json_encode(["success" => false, "message" => $stmt->error]);
    }

    $stmt->close();
}

$conn->close();
?>
