<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include '../db.php';

$message_id = $_POST['message_id'] ?? null;

if ($message_id) {
    // Obtener el ID del grupo y el remitente de este mensaje antes de eliminarlo
    $query_message = "SELECT group_id, sender_id FROM groupmessages WHERE idgroupmessages = ?";
    $stmt_message = $conn->prepare($query_message);
    $stmt_message->bind_param("i", $message_id);
    $stmt_message->execute();
    $result_message = $stmt_message->get_result();
    $message_data = $result_message->fetch_assoc();

    if ($message_data) {
        // Eliminar el mensaje del grupo
        $query_delete = "DELETE FROM groupmessages WHERE idgroupmessages = ?";
        $stmt_delete = $conn->prepare($query_delete);
        $stmt_delete->bind_param("i", $message_id);

        if ($stmt_delete->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Mensaje eliminado correctamente']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Error al eliminar el mensaje']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Mensaje no encontrado']);
    }

    $stmt_message->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Datos incompletos']);
}

$conn->close();
?>
