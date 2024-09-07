<?php
// Conexión a la base de datos
$conn = new mysqli('localhost', 'nombre_usuario', 'contrasena', 'proyecto');

// Verificar si la conexión fue exitosa
if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => "Error de conexión: " . $conn->connect_error]));
}

// Obtener datos del cuerpo de la solicitud POST y validar que no estén vacíos
$email = isset($_POST['email']) ? $_POST['email'] : '';
$nombre_usuario = isset($_POST['nombre_usuario']) ? $_POST['nombre_usuario'] : '';
$contrasena = isset($_POST['contrasena']) ? $_POST['contrasena'] : '';

if (empty($email) || empty($nombre_usuario) || empty($contrasena)) {
    die(json_encode(['success' => false, 'message' => 'Todos los campos son obligatorios']));
}

// Encriptar la contraseña
$contrasena_hash = password_hash($contrasena, PASSWORD_DEFAULT);

// Preparar la consulta para insertar el nuevo usuario
$stmt = $conn->prepare("INSERT INTO usuarios (email, nombre_usuario, contrasena) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $email, $nombre_usuario, $contrasena_hash);

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
