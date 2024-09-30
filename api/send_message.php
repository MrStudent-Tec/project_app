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
    $sender = $_POST['sender'];
    $receiver = $_POST['receiver'];
    $message = $_POST['message'];
    $isseen = 0; // Por defecto, el mensaje no ha sido visto
    $messageId = uniqid();

    $sql = "INSERT INTO chats (sender, receiver, message, isseen, messageId) VALUES (?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssis", $sender, $receiver, $message, $isseen, $messageId);
    
    if ($stmt->execute()) {
        echo json_encode(array("status" => "success"));
    } else {
        echo json_encode(array("status" => "error"));
    }

    $stmt->close();
    $conn->close();
}
?>