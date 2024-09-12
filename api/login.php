<?php
// Habilitar CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
// Conexión a la base de datos
$conn = new mysqli('localhost', 'root', '', 'ubook');

// Verificar si la conexión fue exitosa
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

// Obtener datos del cuerpo de la solicitud POST
$email = $_POST['email'];
$contrasena = $_POST['contrasena'];

// Buscar el usuario por correo
$sql = "SELECT * FROM usuario WHERE email='$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Si el usuario existe, verificar la contraseña
    $row = $result->fetch_assoc();
    if (password_verify($contrasena, $row['contrasena'])) {
        echo json_encode(['success' => true, 'message' => 'Inicio de sesión exitoso']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Contraseña incorrecta']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Usuario no encontrado']);
}

// Cerrar conexión
$conn->close();
?>
