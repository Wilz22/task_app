<?php

    $servername= "localhost";
    $username = "root";
    $password = "";
    $dbname = "task_db";
    $table = "random_messages";

    $action = $_POST["action"];

    $conn = new mysqli($servername, $username, $password, $dbname);

    if($conn->connect_error){
        die("Connection failed: " . $conn->connect_error);
        return;
    }

    if("GET_RANDOM" == $action){
        $result = $conn->query("SELECT id_mensaje, mensaje FROM $table");
        $messages = array();

        if($result->num_rows > 0){
            while($row = $result->fetch_assoc()){
                array_push($messages, $row);
            }
            echo json_encode($messages);
        }else{
            echo "error";
        }
        $conn->close();
        return;
        
    }

    if("GET_ALL" == $action){
        $result = $conn->query("SELECT id_mensaje, mensaje FROM $table ORDER BY RAND() LIMIT 1");
        $messages = array();

        if($result->num_rows > 0){
            while($row = $result->fetch_assoc()){
                array_push($messages, $row);
            }
            echo json_encode($messages);
        }else{
            echo "error";
        }
        $conn->close();
        return;
        
    }

    if("ADD_MSG" == $action){
        $message = $_POST["message"];
        $result = $conn->query("INSERT INTO $table (mensaje) VALUES ('$message')");
        echo "Message added";
        $conn->close();
        return;
    }

    if("DELETE_MSG" == $action){
        $id = $_POST["id"];
        $result = $conn->query("DELETE FROM $table WHERE id_mensaje = $id");
        echo "Message deleted";
        $conn->close();
        return;
    }

    if("UPDATE_MSG" == $action){
        $id = $_POST["id"];
        $message = $_POST["message"];
        $result = $conn->query("UPDATE $table SET mensaje = '$message' WHERE id_mensaje = $id");
        echo "Message updated";
        $conn->close();
        return;
    }

?>