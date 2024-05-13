
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Response.dart';
import 'package:pj4mb/models/SavingGoal/SavingGoal.dart';
import 'package:pj4mb/models/SavingGoal/TransactionWithSaving.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
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
    print(bodyValue);
    print(response.statusCode);
    print(response.body);
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

  Future<List<SavingGoal>> findFinishedByUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(Uri.parse(EndPoint.findFinishedByUserId.replaceAll('{id}', userid.toString())),headers: headersValue);

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

  Future<List<SavingGoal>> findWorkingByUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(Uri.parse(EndPoint.findWorkingByUserId.replaceAll('{id}', userid.toString())),headers: headersValue);
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

  Future<List<TransactionData>> GetTransactionWithSaving (TransactionWithSaving param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    param.userId = int.parse(userid!);
    print(param.toJson());
    final response = await http
        .post(Uri.parse(EndPoint.GetTransactionWithSaving),body: jsonEncode(param.toJson()),headers: headersValue);
        print(response.statusCode);
        print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
      List<TransactionData> transacionList = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          transacionList.add(TransactionData.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return transacionList;
    } else {
      return [];
    }
  }

  Future<List<SavingGoal>> GetSavingWithSavingID (TransactionWithSaving param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    param.userId = int.parse(userid!);
    print(param.toJson());
    final response = await http
        .post(Uri.parse(EndPoint.getSavingWithSavingID),body: jsonEncode(param.toJson()),headers: headersValue);
        print(response.statusCode);
        print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
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