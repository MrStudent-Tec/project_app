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
    $userId = $_POST['user_id'];
    $message = $_POST['message'];
    $chatId = $_POST['chat_id'];

    // Validar campos vacíos
    if (empty($userId) || empty($message) || empty($chatId)) {
        echo json_encode(['success' => false, 'message' => 'Campos faltantes']);
        exit();
    }

    // Guardar el mensaje en la base de datos
    //$sql = "INSERT INTO mensajes (user_id, chat_id, mensaje) VALUES ('$userId', '$chatId', '$message')";
    $sql = "INSERT INTO `mensajeria`(`num_mensajeria`, `mensajeria_texto`, `mensajeria_galeria`, `fecha_mensajeria`) VALUES ('','','','')";
    
    if ($conn->query($sql) === TRUE) {
        echo json_encode(['success' => true, 'message' => 'Mensaje enviado']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Error al enviar el mensaje']);
    }
}

$conn->close();
?>
