import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '/models/task_list.dart';

class ConnectionServicesTasks {
  static const root = 'http://192.168.100.50/crud_operations.php';
  static const getAllTask = 'GET_ALL_TASKS';
  static const insertTaskAction = 'ADD_TASK';
  static const deleteAction = 'DELETE_TASK';
  static const updateAction = 'UPDATE_TASK';

  static Future<List<Tasklist>> getAllTasks() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = getAllTask;
      final response = await http.post(Uri.parse(root), body: map);

      if (kDebugMode) {
        print('getAllTasks response status: ${response.statusCode}');
        print('getAllTasks response body: ${response.body}');
      }
      if (200 == response.statusCode) {
        List<Tasklist> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      if (kDebugMode) {
        print('getAllTasks error: $e');
      }
      return List<Tasklist>.empty();
    }
    return List<Tasklist>.empty();
  }

  static List<Tasklist> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Tasklist>((json) => Tasklist.fromJson(json)).toList();
  }

  static Future<bool> insertTask(String task, int id_message) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = insertTaskAction;
      map['task'] = task;
      map['id_message'] = id_message.toString();
      final response = await http.post(Uri.parse(root), body: map);
      if (kDebugMode) {
        print('insertTaskAction response status: ${response.statusCode}');
        print('insertTaskAction response body: ${response.body}');
      }
      if (200 == response.statusCode) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('insertTaskAction error: $e');
      }
      return false;
    }
    return false;
  }

  static Future<bool> deleteTask(int id) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = deleteAction;
      map['id'] = id.toString();
      final response = await http.post(Uri.parse(root), body: map);
      if (kDebugMode) {
        print('deleteTask response status: ${response.statusCode}');
        print('deleteTask response body: ${response.body}');
      }
      if (200 == response.statusCode) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('deleteTask error: $e');
      }
      return false;
    }
    return false;
  }

  static Future<bool> updateTask(int id, String task, int id_message) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = updateAction;
      map['id'] = id.toString();
      map['task'] = task;
      map['id_message'] = id_message.toString();
      final response = await http.post(Uri.parse(root), body: map);
      if (kDebugMode) {
        print('updateTask response status: ${response.statusCode}');
        print('updateTask response body: ${response.body}');
      }
      if (200 == response.statusCode) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('updateTask error: $e');
      }
      return false;
    }
    return false;
  }
}
