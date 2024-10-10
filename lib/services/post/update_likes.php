<?php
// Habilitar CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include '../db.php'; 

// Actualizar likes
if ($_SERVER['REQUEST_METHOD'] == 'PUT') {
    parse_str(file_get_contents("php://input"), $_PUT);
    $post_id = $_PUT['post_id'] ?? null;
    $action = $_PUT['action'] ?? null; // 'like' o 'unlike'

    if ($post_id && $action) {
        if ($action == 'like') {
            $stmt = mysqli_prepare($conn, "UPDATE posts SET likes = likes + 1 WHERE post_id = ?");
        } else {
            $stmt = mysqli_prepare($conn, "UPDATE posts SET likes = likes - 1 WHERE post_id = ?");
        }
        
        mysqli_stmt_bind_param($stmt, "i", $post_id);
        mysqli_stmt_execute($stmt);

        if (mysqli_stmt_affected_rows($stmt) > 0) {
            echo json_encode(['message' => 'Like actualizado']);
        } else {
            echo json_encode(['message' => 'No se encontró el post o no se realizaron cambios.']);
        }

        mysqli_stmt_close($stmt);
    } else {
        echo json_encode(['message' => 'Datos incompletos']);
    }
}
?>

