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

  $name = $_POST['name'];
  $lastMessage = $_POST['lastMessage'];

  $sql = "INSERT INTO grupos (nombre, ultimo_mensaje, imagen) VALUES ('$name', '$lastMessage', 'URL_IMAGEN')";

  if ($conexion->query($sql) === TRUE) {
      echo json_encode(["success" => true]);
  } else {
      echo json_encode(["success" => false, "error" => $conexion->error]);
  }

  $conexion->close();
?>
