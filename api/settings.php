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

// Verificar si se hizo la solicitud correctamente
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $facebook = $_POST['facebook'];
    $instagram = $_POST['instagram'];
    $userId = $_POST['id_usuario']; // Identificador del usuario para actualizar el registro

    $profileImagePath = null;
    $coverImagePath = null;

    // Subir la imagen de perfil si existe
    if (isset($_FILES['perfil'])) {
        $profileImage = $_FILES['perfil'];
        $profileImagePath = 'uploads/perfil_' . time() . '_' . basename($profileImage['name']);
        move_uploaded_file($profileImage['tmp_name'], $profileImagePath);
    }

    // Subir la imagen de portada si existe
    if (isset($_FILES['portada'])) {
        $coverImage = $_FILES['portada'];
        $coverImagePath = 'uploads/portada_' . time() . '_' . basename($coverImage['name']);
        move_uploaded_file($coverImage['tmp_name'], $coverImagePath);
    }

    // Actualizar los datos del usuario en la base de datos
    $sql = "UPDATE usuario SET facebook = ?, instagram = ?";

    if ($profileImagePath) {
        $sql .= ", perfil = ?";
    }

    if ($coverImagePath) {
        $sql .= ", portada = ?";
    }

    $sql .= " WHERE id_usuario = ?";

    $stmt = $conn->prepare($sql);

    // Vincular los parámetros a la consulta SQL
    if ($profileImagePath && $coverImagePath) {
        $stmt->bind_param("ssssi", $facebook, $instagram, $profileImagePath, $coverImagePath, $userId);
    } elseif ($profileImagePath) {
        $stmt->bind_param("sssi", $facebook, $instagram, $profileImagePath, $userId);
    } elseif ($coverImagePath) {
        $stmt->bind_param("sssi", $facebook, $instagram, $coverImagePath, $userId);
    } else {
        $stmt->bind_param("ssi", $facebook, $instagram, $userId);
    }

    // Ejecutar la consulta
    if ($stmt->execute()) {
        $response = [
            'status' => 'success',
            'message' => 'Datos actualizados correctamente'
        ];
    } else {
        $response = [
            'status' => 'error',
            'message' => 'Error al actualizar los datos'
        ];
    }

    // Cerrar la declaración y la conexión
    $stmt->close();
    $conn->close();
    
    // Enviar respuesta como JSON
    echo json_encode($response);
}
?>
