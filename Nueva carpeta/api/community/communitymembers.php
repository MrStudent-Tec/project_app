<?php
include 'db_connection.php';

$community_id = $_GET['community_id'];

$query = "SELECT users.user_id, users.user_name, users.user_image 
          FROM community_members 
          JOIN users ON community_members.user_id = users.user_id 
          WHERE community_members.community_id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $community_id);
$stmt->execute();
$result = $stmt->get_result();

$members = array();

while ($row = $result->fetch_assoc()) {
    $members[] = array(
        'user_id' => $row['user_id'],
        'user_name' => $row['user_name'],
        'user_image' => $row['user_image']
    );
}

echo json_encode($members);
?>
