<?php
// Conexión a la base de datos
$conn = new mysqli('localhost', 'root', '', 'ubook');

// Verificar si la conexión fue exitosa
if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => "Error de conexión: " . $conn->connect_error]));
}

// Obtener datos del cuerpo de la solicitud POST y validar que no estén vacíos
$id_usuario = isset($_POST['id_usuario']) ? $_POST['id_usuario'] : '';
$nombre_usuario = isset($_POST['nombre_usuario']) ? $_POST['nombre_usuario'] : '';
$email = isset($_POST['email']) ? $_POST['email'] : '';
$contrasena = isset($_POST['contrasena']) ? $_POST['contrasena'] : '';
$fec_nac = isset($_POST['fec_nac']) ? $_POST['fec_nac'] : '';
$programa = isset($_POST['programa']) ? $_POST['programa'] : '';

if (empty($id_usuario)|| empty($nombre_usuario) || empty($email)  || empty($contrasena) || empty($fec_nac) || empty($programa)) {
    die(json_encode(['success' => false, 'message' => 'Todos los campos son obligatorios']));
}

// Encriptar la contraseña
$contrasena_hash = password_hash($contrasena, PASSWORD_DEFAULT);

// Preparar la consulta para insertar el nuevo usuario
$stmt = $conn->prepare("INSERT INTO usuario (id_usuario, nombre_usuario, email, contrasena, fec_nac, programa) VALUES (?, ?, ?, ?, ?, ?)");
$stmt->bind_param("sss", $id_usuario, $nombre_usuario, $email, $contrasena_hash, $fec_nac, $programa);

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