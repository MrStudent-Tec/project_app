<?php
// Habilitar CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

// Conexión a la base de datos
$conn = new mysqli('localhost', 'root', '', 'ubook');

// Verificar la conexión
if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Conexión fallida: " . $conn->connect_error]);
    exit();
}

// Manejar la solicitud POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Validar que el campo messageId esté presente
    if (!isset($_POST['message_id']) || empty($_POST['message_id'])) {
        echo json_encode(["success" => false, "message" => "message_id es requerido"]);
        exit();
    }

    $messageId = $_POST['message_id'];

    // Preparar y ejecutar la consulta
    $sql = "DELETE FROM messages WHERE message_id = ?";
    $stmt = $conn->prepare($sql);
    if ($stmt === false) {
        echo json_encode(["success" => false, "message" => "Error al preparar la consulta: " . $conn->error]);
        exit();
    }

    $stmt->bind_param("s", $messageId);

    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "Mensaje eliminado exitosamente"]);
    } else {
        echo json_encode(["success" => false, "message" => "Error al ejecutar: " . $stmt->error]);
    }

    $stmt->close();
}

$conn->close();
?>
