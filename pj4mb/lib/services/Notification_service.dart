import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Notification/Notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationService{
  Future<List<NotificationDTO>> GetNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    
    final response = await http
        .get(Uri.parse(EndPoint.GetNotification.replaceAll("{id}", userid!)),headers: headersValue);
        print(response.body);
        print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
      List<NotificationDTO> noti = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          noti.add(NotificationDTO.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return noti;
    } else {
      return [];
    }
  }

  Future<bool> UpdateNotification(NotificationDTO param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    param.userId = int.parse(userid!);
    
    var bodyValue = jsonEncode(param.toJson());
    final response = await http
        .put(Uri.parse(EndPoint.UpdateNotification.replaceAll("{id}", param.id.toString())),body: bodyValue,headers: headersValue);
        print(response.body);
        print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}