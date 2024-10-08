<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$conn = new mysqli('localhost', 'root', '', 'ubook');

// Verificar la conexión y retornar JSON en caso de error
if ($conn->connect_error) {
    echo json_encode(array("status" => "error", "message" => "Error de conexión a la base de datos"));
    exit();
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $sender_id = $_POST['sender'] ?? null;
    $receiver_id = $_POST['receiver'] ?? null;
    $message = $_POST['message'] ?? null;
    $is_seenmessages = 0;
    $url = $_POST['url'] ?? null;

    if ($sender_id && $receiver_id && $message) {
        $sql = "INSERT INTO messages (sender_id, receiver_id, message, is_seenmessages, url) VALUES (?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("iisis", $sender_id, $receiver_id, $message, $is_seenmessages, $url);

        if ($stmt->execute()) {
            echo json_encode(array("status" => "success"));
        } else {
            echo json_encode(array("status" => "error", "message" => $stmt->error));
        }

        $stmt->close();
    } else {
        // Error en los parámetros enviados
        echo json_encode(array("status" => "error", "message" => "Datos incompletos o inválidos"));
    }

    $conn->close();
} else {
    echo json_encode(array("status" => "error", "message" => "Método no permitido"));
}
?>
