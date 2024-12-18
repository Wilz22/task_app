import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '/models/msg_list.dart';

class ConnectionServices {
  static const root = 'http://192.168.100.50/api_db.php';
  static const getRandom = 'GET_RANDOM';
  static const getAllAction = 'GET_ALL';
  static const addAction = 'ADD_MSG';
  static const deleteAction = 'DELETE_MSG';
  static const updateAction = 'UPDATE_MSG';

  static Future<List<MsgList>> getAllMsgs() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = getAllAction;
      final response = await http.post(Uri.parse(root), body: map);
      if (kDebugMode) {
        print('getAllMsgs response status: ${response.statusCode}');
        print('getAllMsgs response body: ${response.body}');
      }

      if (200 == response.statusCode) {
        List<MsgList> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      if (kDebugMode) {
        print('getAllMsgs error: $e');
      }
      return List<MsgList>.empty();
    }
    return List<MsgList>.empty();
  }

  static List<MsgList> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody);
    return (parsed['data'] as List)
        .map<MsgList>((json) => MsgList.fromJson(json))
        .toList();
  }

  static Future<bool> addMsg(String mensaje) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = addAction;
      map['mensaje'] = mensaje;
      final response = await http.post(Uri.parse(root), body: map);
      if (kDebugMode) {
        print('addMsg response status: ${response.statusCode}');
        print('addMsg response body: ${response.body}');
      }

      if (200 == response.statusCode) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('addMsg error: $e');
      }
      return false;
    }
    return false;
  }

  static Future<bool> deleteMsg(int id) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = deleteAction;
      map['id_mensaje'] = id.toString();
      final response = await http.post(Uri.parse(root), body: map);
      if (kDebugMode) {
        print('deleteMsg response status: ${response.statusCode}');
        print('deleteMsg response body: ${response.body}');
      }

      if (200 == response.statusCode) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('deleteMsg error: $e');
      }
      return false;
    }
    return false;
  }

  static Future<bool> updateMsg(int id_mensaje, String mensaje) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = updateAction;
      map['id_mensaje'] = id_mensaje.toString(); // Convertir a String
      map['mensaje'] = mensaje;
      final response = await http.post(Uri.parse(root), body: map);
      if (kDebugMode) {
        print('updateMsg response status: ${response.statusCode}');
        print('updateMsg response body: ${response.body}');
      }

      if (200 == response.statusCode) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('updateMsg error: $e');
      }
      return false;
    }
    return false;
  }

  static Future<MsgList> getRandomMsg() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = getRandom;
      final response = await http.post(Uri.parse(root), body: map);
      if (kDebugMode) {
        print('getRandomMsg response status: ${response.statusCode}');
        print('getRandomMsg response body: ${response.body}');
      }

      if (200 == response.statusCode) {
        final parsed = json.decode(response.body);
        return MsgList.fromJson(parsed['data']);
      }
    } catch (e) {
      if (kDebugMode) {
        print('getRandomMsg error: $e');
      }
      return MsgList(id_mensaje: 0, mensaje: '');
    }
    return MsgList(id_mensaje: 0, mensaje: '');
  }
}
