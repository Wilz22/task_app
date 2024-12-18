<?php

    $servername= "localhost";
    $username = "root";
    $password = "";
    $dbname = "task_db";
    $table = "task_list";

    $action = $_POST["action"];

    $conn = new mysqli($servername, $username, $password, $dbname);

    if($conn->connect_error){
        die("Connection failed: " . $conn->connect_error);
        return;
    }

    if("GET_ALL_TASKS" == $action) {
        $query = "
            SELECT 
                $table.id, 
                $table.task, 
                $table.id_message, 
                random_messages.mensaje 
            FROM 
                $table
            INNER JOIN 
                random_messages 
            ON 
                $table.id_message = random_messages.id_mensaje
        ";
        
        $result = $conn->query($query);
        $tasks = array();

        if($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                array_push($tasks, $row); 
            }
            echo json_encode($tasks);
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }

    if("ADD_TASK" == $action) {
        $task = $_POST["task"];
        $id_message = $_POST["id_message"];
        $result = $conn->query("INSERT INTO $table (task, id_message) VALUES ('$task', '$id_message')");
        echo "Task added";
        $conn->close();
        return;
    }

    if("DELETE_TASK" == $action) {
        $id = $_POST["id"];
        $result = $conn->query("DELETE FROM $table WHERE id = $id");
        echo "Task deleted";
        $conn->close();
        return;
    }

    if("UPDATE_TASK" == $action) {
        $id = $_POST["id"];
        $task = $_POST["task"];
        $id_message = $_POST["id_message"];
        $result = $conn->query("UPDATE $table SET task = '$task', id_message = '$id_message' WHERE id = $id");
        echo "Task updated";
        $conn->close();
        return;
    }

?>