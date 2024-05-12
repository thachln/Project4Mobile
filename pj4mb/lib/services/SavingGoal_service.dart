
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Response.dart';
import 'package:pj4mb/models/SavingGoal/SavingGoal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavingGoalService{
  Future<ResponseApi> CreateSavingGoal(SavingGoal param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    param.userId = int.parse(userid!);
    var bodyValue = jsonEncode(param.toJson());
    final response = await http.post(Uri.parse(EndPoint.InsertGoal),body: bodyValue,headers: headersValue);
  
    if (response.statusCode == 200) {     
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    } else {
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    }
  }


  Future<ResponseApi> UpdateGoal(SavingGoal param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    param.userId = int.parse(userid!);
    var bodyValue = jsonEncode(param.toJson());
    final response = await http.put(Uri.parse(EndPoint.UpdateGoal.replaceAll('{id}', param.id.toString())),body: bodyValue,headers: headersValue);
  
    if (response.statusCode == 200) {     
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    } else {
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    }
  }

  Future<ResponseApi> DeleteGoal(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.delete(Uri.parse(EndPoint.DeleteGoal.replaceAll('{id}', id.toString())),headers: headersValue);
  
    if (response.statusCode == 200) {     
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    } else {
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    }
  }

  Future<List<SavingGoal>> GetGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(Uri.parse(EndPoint.GetGoal.replaceAll('{id}', userid.toString())),headers: headersValue);
  
    if (response.statusCode == 200) {     
      final List<dynamic> parsed = jsonDecode(response.body);
      List<SavingGoal> savingList = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          savingList.add(SavingGoal.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return savingList;
    } else {   
      return [];
    }
  }
}