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


$target_dir = "uploads/";
$target_file = $target_dir . basename($_FILES["file"]["name"]);
$imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) {
    echo json_encode(['success' => true, 'message' => 'Archivo subido', 'file_path' => $target_file]);
} else {
    echo json_encode(['success' => false, 'message' => 'Error al subir el archivo']);
}
?>
