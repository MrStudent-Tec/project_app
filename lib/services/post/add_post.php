<?php
// Habilitar CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include '../db.php'; 

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'] ?? null;
    $content = $_POST['content'] ?? null;

    if ($user_id && $content) {
        // Preparar y ejecutar la consulta usando mysqli
        $stmt = mysqli_prepare($conn, "INSERT INTO posts (user_id, content) VALUES (?, ?)");
        mysqli_stmt_bind_param($stmt, "is", $user_id, $content);
        
        if (mysqli_stmt_execute($stmt)) {
            echo json_encode(['message' => 'Publicación añadida exitosamente']);
        } else {
            echo json_encode(['message' => 'Error al añadir publicación: ' . mysqli_error($conn)]);
        }

        mysqli_stmt_close($stmt);
    } else {
        echo json_encode(['message' => 'Datos incompletos']);
    }
}
?>
