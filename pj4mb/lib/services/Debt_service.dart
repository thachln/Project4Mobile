import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Debt/Debt.dart';
import 'package:pj4mb/models/Response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DebthService {
  Future<ResponseApi> InsertDebt(Debt debt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    debt.userId = int.parse(userid!);
   var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .post(Uri.parse(EndPoint.InsertDebt), body: jsonEncode(debt.toJson()),headers: headersValue);
   print(response.statusCode);
   if (response.statusCode == 201) {     
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    } else {
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    }
  }

  Future<ResponseApi> UpdateDebt(Debt debt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    debt.userId = int.parse(userid!);
   var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .put(Uri.parse(EndPoint.UpdateDebt.replaceAll('{id}', debt.id.toString())), body: jsonEncode(debt.toJson()),headers: headersValue);
   
    if (response.statusCode == 200) {     
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    } else {
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    }
  }

  Future<ResponseApi> DeleteDebt(int debtId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
   var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .delete(Uri.parse(EndPoint.DeleteDebt.replaceAll('{id}', debtId.toString())),headers: headersValue);
   
    if (response.statusCode == 200) {     
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    } else {
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    }
  }

  Future<Debt> getDebtByUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
   var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .get(Uri.parse(EndPoint.getDebtByUserId.replaceAll('{id}', userid!)),headers: headersValue);
   
    if (response.statusCode == 200) {     
      Debt debt = Debt.fromJson(jsonDecode(response.body));
      return debt;
    } else {
      return Debt(id: 0, userId: 0, categoryId: 0, creditor: '', amount: 0, dueDate: DateTime.now(), paidDate: DateTime.now(), isPaid: false, notes: '', name: '');
    }
  }

  Future<Debt> getDebtById(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
   var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .get(Uri.parse(EndPoint.getDebtById.replaceAll('{id}', id.toString())),headers: headersValue);
   
    if (response.statusCode == 200) {     
      Debt debt = Debt.fromJson(jsonDecode(response.body));
      return debt;
    } else {
      return Debt(id: 0, userId: 0, categoryId: 0, creditor: '', amount: 0, dueDate: DateTime.now(), paidDate: DateTime.now(), isPaid: false, notes: '', name: '');
    }
  }

  
}