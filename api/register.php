<?php
// Habilitar CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Conexión a la base de datos
$conn = new mysqli('localhost', 'root', '', 'ubook');

// Verificar si la conexión fue exitosa
if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => "Error de conexión: " . $conn->connect_error]));
}

// Obtener datos del cuerpo de la solicitud POST y validar que no estén vacíos
$id_usuario = isset($_POST['id_usuario']) ? $_POST['id_usuario'] : '';
$correo = isset($_POST['correo']) ? $_POST['correo'] : '';
$nombre_usuario = isset($_POST['nombre_usuario']) ? $_POST['nombre_usuario'] : '';
$contrasena = isset($_POST['contrasena']) ? $_POST['contrasena'] : '';
$fecha_nac = isset($_POST['fecha_nac']) ? $_POST['fecha_nac'] : '';
$programa = isset($_POST['programa']) ? $_POST['programa'] : '';

// Validación de campos vacíos
if (empty($id_usuario) || empty($correo) || empty($nombre_usuario) || empty($contrasena) || empty($fecha_nac) || empty($programa)) {
    die(json_encode(['success' => false, 'message' => 'Todos los campos son obligatorios']));
}

// Encriptar la contraseña
$contrasena_hash = password_hash($contrasena, PASSWORD_DEFAULT);

// Preparar la consulta para insertar el nuevo usuario
$stmt = $conn->prepare("INSERT INTO usuario (id_usuario, nombre_usuario, correo, contrasena, fecha_nac, programa) VALUES (?, ?, ?, ?, ?, ?)");
$stmt->bind_param("isssss", $id_usuario, $nombre_usuario, $correo, $contrasena_hash, $fecha_nac, $programa);

// Ejecutar la consulta y verificar si fue exitosa
if ($stmt->execute()) {
    echo json_encode(['success' => true, 'message' => 'Usuario registrado con éxito']);
} else {
    echo json_encode(['success' => false, 'message' => 'Error: ' . $stmt->error]);
}

// Cerrar la sentencia y la conexión
$stmt->close();
$conn->close();
?>


