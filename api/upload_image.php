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

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['image'])) {
    $image = $_FILES['image']['tmp_name'];
    $imageFileType = strtolower(pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION));

    // Validar que el archivo sea una imagen (JPG, PNG, GIF)
    $validExtensions = array("jpg", "jpeg", "png", "gif");
    if (!in_array($imageFileType, $validExtensions)) {
        echo json_encode(array("status" => "error", "message" => "Tipo de archivo no permitido"));
        exit;
    }

    // Generar un nombre único para la imagen
    $imagePath = 'uploads/' . uniqid() . '.' . $imageFileType;

    // Mover la imagen al directorio
    if (move_uploaded_file($image, $imagePath)) {
        echo json_encode(array("status" => "success", "url" => $imagePath));
    } else {
        echo json_encode(array("status" => "error", "message" => "Error al subir el archivo"));
    }
}
?>
