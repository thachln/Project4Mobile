import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Budget/Budget.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Response.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
///budgets/create

class Budget_Service{

  Future<ResponseApi> InsertBudget(Budget budget) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    budget.userId = int.parse(userid!);
   var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print(budget.toJson());
    final response = await http
        .post(Uri.parse(EndPoint.InsertBudget), body: jsonEncode(budget.toJson()),headers: headersValue);
     
    if (response.statusCode == 200) {
      return ResponseApi(status: response.statusCode, message: response.body, data: 'data');
    }    
    else{
      return ResponseApi(status: response.statusCode, message: response.body, data: 'data');
    }
  }

  Future<Budget> GetBudgetById(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('userid');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  
    
    var url = Uri.parse(EndPoint.GetBudgetWithID.replaceAll('{id}',id.toString()));
    var response = await http.get(url, headers: headersValue);
    if (response.statusCode == 200) {
   
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
      Budget transaction = Budget.fromJson(parsed);
      return transaction;
    } 
    else{
      return Budget(budgetId: 0, userId: 0, categoryId: 0, amount: 0, threshold_amount: 0, period_start: DateTime.now(), period_end: DateTime.now() );
    }
      
  }

  Future<List<BudgetResponse>> GetBudgetWithTime(ParamPudget paramPudget) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    paramPudget.userId = int.parse(userid!);
 
    final response = await http
        .post(Uri.parse(EndPoint.GetBudgetWithTime),body: jsonEncode(paramPudget.toJson()),headers: headersValue);

    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
   
      List<BudgetResponse> BudgetList = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          BudgetList.add(BudgetResponse.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return BudgetList;
    } else {
      return [];
    }
  }

  Future<ResponseApi> UpdateBudget(Budget bud) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
     bud.userId = int.parse(userid!);
    var bodyValue = jsonEncode(bud.toJson());
    final response = await http.put(Uri.parse(EndPoint.UpdateBudget.replaceAll('{id}',bud.budgetId.toString())),body: bodyValue,headers: headersValue);
 
    if (response.statusCode == 200) {     
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    } else {
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    }
  }

  Future<ResponseApi> DeleteBudget(int budgetId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.delete(Uri.parse(EndPoint.DeleteBudget.replaceAll("{id}", budgetId.toString())),headers: headersValue);

    if (response.statusCode == 204) {     
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    } else {
      ResponseApi responseApi = new ResponseApi(message: response.body, status: response.statusCode, data: '');
      return responseApi;
    }
  }

  Future<List<TransactionData>> GetTransactionWithBudget(BugetParam paramPudget) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    paramPudget.userId = int.parse(userid!);

    final response = await http
        .post(Uri.parse(EndPoint.GetTransactionWithBudget),body: jsonEncode(paramPudget.toJson()),headers: headersValue);
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
}