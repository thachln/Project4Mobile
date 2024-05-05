import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Response.dart';
import 'package:pj4mb/models/Transaction/Transaction.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class TransactionService {

  Future<List<TransactionView>> getTop5NewTransaction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse(EndPoint.Get5TransactionNewest.replaceAll("{userId}", prefs.getString('userid')!));
    var response = await http.get(url, headers: headersValue);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
      List<TransactionView> transaction = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          transaction.add(TransactionView.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return transaction;
    }
    else{
      return [];
    }
      
  }

  Future<List<TransactionView>> getTop5TransactionHightestMoney(ParamPudget param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var userId = prefs.getString('userid');
    param.userId = int.parse(userId!);
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var bodyValue = jsonEncode(param.toJson());
    var url = Uri.parse(EndPoint.Get5TransactionHigtest);
    var response = await http.post(url, body: bodyValue,headers: headersValue);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
      List<TransactionView> transaction = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          transaction.add(TransactionView.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return transaction;
    }
    else{
      return [];
    }
      
  }

  Future<List<TransactionData>> GetTransactionWithTime(ParamPudget param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('userid');
    param.userId = int.parse(user!);
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var bodyValue = jsonEncode(param.toJson());
    var url = Uri.parse(EndPoint.GetTransactionWithTime);
    var response = await http.post(url,body: bodyValue, headers: headersValue);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      List<TransactionData> transaction = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          transaction.add(TransactionData.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return transaction;
    }
    else{
      return [];
    }
      
  }

  Future<List<TransactionReport>> GetTransactionReport(ParamPudget param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('userid');
    param.userId = int.parse(user!);
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    print(param.toJson());
    var bodyValue = jsonEncode(param.toJson());
    var url = Uri.parse(EndPoint.GetTransactionReport);
    print(url);
    var response = await http.post(url,body: bodyValue, headers: headersValue);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
      List<TransactionReport> transaction = [];
     
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          transaction.add(TransactionReport.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return transaction;
    }
    else{
      return [];
    }
      
  }

  Future<List<TransactionReport>> GetTransactionReportMonth(ParamPudget param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('userid');
    param.userId = int.parse(user!);
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    print(param.toJson());
    var bodyValue = jsonEncode(param.toJson());
    var url = Uri.parse(EndPoint.GetTransactionReportMonth);
    print(url);
    var response = await http.post(url,body: bodyValue, headers: headersValue);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
      List<TransactionReport> transaction = [];
     
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          transaction.add(TransactionReport.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return transaction;
    }
    else{
      return [];
    }
      
  }

  Future<Transaction> GetTransactionById(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('userid');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  
    
    var url = Uri.parse(EndPoint.GetTransactionById.replaceAll('{id}',id.toString()));
    var response = await http.get(url, headers: headersValue);
    if (response.statusCode == 200) {
      print(response.body);
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
      Transaction transaction = Transaction.fromJson(parsed);
      return transaction;
    } 
    else{
      return Transaction(transactionId: 0, amount: 0, categoryId: 0, notes: '', transactionDate: DateTime.now(), userId: 0, walletId: 0);
    }
      
  }

  Future<bool> InsertTransaction(Transaction trans) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    trans.userId = int.parse(userid!);
    final response = await http.post(Uri.parse(EndPoint.InsertTransaction),body: jsonEncode(trans.toJson()),headers: headersValue);
    print(response.statusCode);
    if (response.statusCode == 200) {     
      return true;
    } else {
      return false;
    }
  }

  Future<ResponseApi> UpdateTransaction(Transaction trans) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var bodyValue = jsonEncode(trans.toJson());
    trans.userId = int.parse(userid!);
    final response = await http.put(Uri.parse(EndPoint.UpdateTransaction.replaceAll('{id}',trans.transactionId.toString())),body: bodyValue,headers: headersValue);
    print(response.statusCode);
    if (response.statusCode == 200) {     
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    } else {
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    }
  }

  Future<ResponseApi> DeleteTransaction(int transId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.delete(Uri.parse(EndPoint.DeleteTransaction.replaceAll("{id}", transId.toString())),headers: headersValue);
    print(response.statusCode);
    if (response.statusCode == 204) {     
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    } else {
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    }
  }
  
  
}