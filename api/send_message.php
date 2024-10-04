<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$conn = new mysqli('localhost', 'root', '', 'ubook');

// Verificar la conexión
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $sender_id = $_POST['sender_id'];
    $receiver_id = $_POST['receiver_id'];
    $message = $_POST['message'];
    $is_seenmessages = 0; // Por defecto, el mensaje no ha sido visto
    $url = $_POST['url'] ?? NULL; // Puede ser NULL

    // Insertar el mensaje en la base de datos
    $sql = "INSERT INTO messages (sender_id, receiver_id, message, is_seenmessages, url) VALUES (?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("iisis", $sender_id, $receiver_id, $message, $is_seenmessages, $url);

    if ($stmt->execute()) {
        echo json_encode(array("status" => "success"));
    } else {
        echo json_encode(array("status" => "error"));
    }

    $stmt->close();
    $conn->close();
}
?>
