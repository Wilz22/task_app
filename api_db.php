<?php
// Configuración de base de datos
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "task_db";
$table = "random_messages";

try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $action = $_POST["action"] ?? '';

    switch ($action) {
        case "GET_ALL":
            $stmt = $conn->prepare("SELECT id_mensaje, mensaje FROM $table");
            $stmt->execute();
            $messages = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(["status" => "success", "data" => $messages]);
            break;

        case "GET_RANDOM":
            $stmt = $conn->prepare("SELECT id_mensaje, mensaje FROM $table ORDER BY RAND() LIMIT 1");
            $stmt->execute();
            $message = $stmt->fetch(PDO::FETCH_ASSOC);
            echo json_encode(["status" => "success", "data" => $message]);
            break;

        case "ADD_MSG":
            $mensaje = $_POST["mensaje"] ?? '';
            if ($mensaje) {
                $stmt = $conn->prepare("INSERT INTO $table (mensaje) VALUES (:mensaje)");
                $stmt->bindParam(':mensaje', $mensaje);
                $stmt->execute();
                echo json_encode(["status" => "success", "message" => "Message added"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Message is required"]);
            }
            break;

        case "DELETE_MSG":
            $id_mensaje = $_POST["id_mensaje"] ?? 0;
            if ($id_mensaje) {
                $stmt = $conn->prepare("DELETE FROM $table WHERE id_mensaje = :id_mensaje");
                $stmt->bindParam(':id_mensaje', $id_mensaje, PDO::PARAM_INT);
                $stmt->execute();
                echo json_encode(["status" => "success", "message" => "Message deleted"]);
            } else {
                echo json_encode(["status" => "error", "message" => "ID is required"]);
            }
            break;

        case "UPDATE_MSG":
            $id_mensaje = $_POST["id_mensaje"] ?? 0;
            $mensaje = $_POST["mensaje"] ?? '';
            if ($id_mensaje && $mensaje) {
                $stmt = $conn->prepare("UPDATE $table SET mensaje = :mensaje WHERE id_mensaje = :id_mensaje");
                $stmt->bindParam(':id_mensaje', $id_mensaje, PDO::PARAM_INT);
                $stmt->bindParam(':mensaje', $mensaje);
                $stmt->execute();
                echo json_encode(["status" => "success", "message" => "Message updated"]);
            } else {
                echo json_encode(["status" => "error", "message" => "ID and message are required"]);
            }
            break;

        default:
            echo json_encode(["status" => "error", "message" => "Invalid action"]);
            break;
    }
} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>
