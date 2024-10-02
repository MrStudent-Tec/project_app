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
$email = isset($_POST['email']) ? $_POST['email'] : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';

if (empty($email) || empty($password)) {
    die(json_encode(['success' => false, 'message' => 'Email y contraseña son obligatorios']));
}

// Preparar una declaración para buscar el usuario por email en la tabla dateperson
$stmt = $conn->prepare("SELECT * FROM dateperson WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    // Si el usuario existe, verificar la contraseña
    $row = $result->fetch_assoc();
    if (password_verify($password, $row['password'])) {
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
