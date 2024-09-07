<?php
// Conexión a la base de datos
$conn = new mysqli('localhost', 'nombre_usuario', 'contrasena', 'proyecto');

// Verificar si la conexión fue exitosa
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

// Obtener datos del cuerpo de la solicitud POST
$email = $_POST['correo'];
$contrasena = $_POST['contrasena'];

// Buscar el usuario por correo
$sql = "SELECT * FROM usuarios WHERE email='$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Si el usuario existe, verificar la contraseña
    $row = $result->fetch_assoc();
    if (password_verify($contrasena, $row['contrsena'])) {
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
