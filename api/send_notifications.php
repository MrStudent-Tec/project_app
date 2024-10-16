<?php
// Habilitar CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include 'db.php';

// Obtener parámetros
$user_id = $_POST['user_id'];
$title = $_POST['title'];
$message = $_POST['message'];

// Insertar la notificación en la base de datos
$sql = "INSERT INTO notifications (user_id, title, message) VALUES ('$user_id', '$title', '$message')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success", "message" => "Notificación enviada correctamente"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error al enviar la notificación: " . $conn->error]);
}

$conn->close();
?>
