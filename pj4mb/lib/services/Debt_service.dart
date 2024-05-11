import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Debt/Debt.dart';
import 'package:pj4mb/models/Debt/ReportDebt.dart';
import 'package:pj4mb/models/Response.dart';
import 'package:pj4mb/screens/Debt/ReportDebt.dart';
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
      final String responseString = utf8.decode(response.bodyBytes); 
      Map<String, dynamic> jsonData = jsonDecode(responseString);
      Debt debt = Debt.fromJson(jsonData);
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
      final String responseString = utf8.decode(response.bodyBytes); 
      Map<String, dynamic> jsonData = jsonDecode(responseString);
      Debt debt = Debt.fromJson(jsonData);
      return debt;
    } else {
      return Debt(id: 0, userId: 0, categoryId: 0, creditor: '', amount: 0, dueDate: DateTime.now(), paidDate: DateTime.now(), isPaid: false, notes: '', name: '');
    }
  }

  Future<List<Debt>> findDebtActive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
   var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .get(Uri.parse(EndPoint.findDebtActive.replaceAll('{id}', userid!)),headers: headersValue);
   
    if (response.statusCode == 200) {     
      final String responseString = utf8.decode(response.bodyBytes); 
      final List<dynamic> parsed = jsonDecode(responseString);    
      List<Debt> debt = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          debt.add(Debt.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return debt;   
    } else {
      return [];
    }
  }

  Future<List<Debt>> findDebtPaid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
   var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .get(Uri.parse(EndPoint.findDebtPaid.replaceAll('{id}', userid!)),headers: headersValue);
   
    if (response.statusCode == 200) {     
      final String responseString = utf8.decode(response.bodyBytes); 
      final List<dynamic> parsed = jsonDecode(responseString); 
      List<Debt> debt = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          debt.add(Debt.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return debt;   
    } else {
      return [];
    }
  }

  Future<ResponseApi> updateIsPaid(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
   var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .get(Uri.parse(EndPoint.UpdateIsPaid.replaceAll('{id}', id.toString())),headers: headersValue);
   
    if (response.statusCode == 200) {     
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    } else {
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    }
  }

  Future<List<ReportDebtData>> getReportDebt(ParamPudget param) async {
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
        .post(Uri.parse(EndPoint.GetReportDebt),body: bodyValue,headers: headersValue);
    if (response.statusCode == 200) {     
      final String responseString = utf8.decode(response.bodyBytes); 
      final List<dynamic> parsed = jsonDecode(responseString);
      
      List<ReportDebtData> debt = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          
          debt.add(ReportDebtData.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return debt;
    } else {
      return [];
    }
  }

  Future<List<DetailReportDebtData>> getDetailReport(GetDetailReportDebtParam param) async {
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
        .post(Uri.parse(EndPoint.getDetailDebtReport),body: bodyValue,headers: headersValue);
    if (response.statusCode == 200) {     
      final String responseString = utf8.decode(response.bodyBytes); 
      final List<dynamic> parsed = jsonDecode(responseString);
      
      List<DetailReportDebtData> debt = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {    
          var result = DetailReportDebtData.fromJson(item);
          result.index = param.index;
          debt.add(result);
        } else {
          throw Exception('Invalid item format');
        }
      }
      return debt;
    } else {
      return [];
    }
  }

  Future<List<Debt>> findDebt(ParamPudget param) async {
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
        .post(Uri.parse(EndPoint.FindDebt),body: bodyValue,headers: headersValue);
   
    if (response.statusCode == 200) {     
      final String responseString = utf8.decode(response.bodyBytes); 
      final List<dynamic> parsed = jsonDecode(responseString);   
      List<Debt> debt = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          debt.add(Debt.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return debt;   
    } else {
      return [];
    }
  }


  Future<List<Debt>> findLoan(ParamPudget param) async {
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
        .post(Uri.parse(EndPoint.FindLoan),body: bodyValue,headers: headersValue);
   
    if (response.statusCode == 200) {     
      final String responseString = utf8.decode(response.bodyBytes); 
      final List<dynamic> parsed = jsonDecode(responseString);    

      List<Debt> debt = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          debt.add(Debt.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return debt;   
    } else {
      return [];
    }
  }
}