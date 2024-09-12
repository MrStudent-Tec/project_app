<?php
// Habilitar CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Establecer el tipo de contenido de la respuesta a JSON
header('Content-Type: application/json');

// Conexión a la base de datos
$conn = new mysqli('localhost', 'root', '', 'ubook');

// Verificar si la conexión fue exitosa
if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => "Error de conexión: " . $conn->connect_error]));
}

// Obtener datos del cuerpo de la solicitud POST y validarlos
$correo = isset($_POST['correo']) ? $_POST['correo'] : '';
$contrasena = isset($_POST['contrasena']) ? $_POST['contrasena'] : '';

if (empty($correo) || empty($contrasena)) {
    die(json_encode(['success' => false, 'message' => 'Correo y contraseña son obligatorios']));
}

// Preparar una declaración para buscar el usuario por correo
$stmt = $conn->prepare("SELECT * FROM usuario WHERE correo = ?");
$stmt->bind_param("s", $correo);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    // Si el usuario existe, verificar la contraseña
    $row = $result->fetch_assoc();
    if (password_verify($contrasena, $row['contrasena'])) {
        echo json_encode(['success' => true, 'message' => 'Inicio de sesión exitoso']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Usuario o contraseña incorrectos']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Usuario o contraseña incorrectos']);
}

// Cerrar la declaración y la conexión
$stmt->close();
$conn->close();
?>
