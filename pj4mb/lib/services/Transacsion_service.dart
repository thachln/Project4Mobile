import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
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

  Future<List<TransactionView>> getTop5TransactionHightestMoney() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse(EndPoint.Get5TransactionHigtest.replaceAll("{userId}", prefs.getString('userid')!));
    var response = await http.get(url, headers: headersValue);
    print(url);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
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
  
  
}