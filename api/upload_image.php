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
    $imagePath = 'uploads/' . uniqid() . '.jpg';
    
    if (move_uploaded_file($image, $imagePath)) {
        echo json_encode(array("status" => "success", "url" => $imagePath));
    } else {
        echo json_encode(array("status" => "error"));
    }
}
?>