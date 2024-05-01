import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Budget/Budget.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
///budgets/create

class Budget_Service{

  Future<bool> InsertBudget(Budget budget) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    budget.userId = int.parse(userid!);
   var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .post(Uri.parse(EndPoint.InsertBudget), body: jsonEncode(budget.toJson()),headers: headersValue);
        print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    }    
    else{
      return false;
    }
  }

  Future<List<Budget>> GetBudgetWithTime(ParamPudget paramPudget) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .post(Uri.parse(EndPoint.GetBudgetWithTime),body: jsonEncode(paramPudget.toJson()),headers: headersValue);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
      List<Budget> BudgetList = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          BudgetList.add(Budget.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return BudgetList;
    } else {
      return [];
    }
  }
}