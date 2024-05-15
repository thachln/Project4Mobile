import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Bill/EndType.dart';
import 'package:pj4mb/models/Bill/MonthOption.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/Response.dart';
import 'package:pj4mb/models/TransactionRecurrence/TransRecuResponce.dart';
import 'package:pj4mb/models/TransactionRecurrence/TransactionRecurrence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TransactionRecurrence_Service {
  Future<ResponseApi> InsertTransRe(TransactionRecurrence transRe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    transRe.userId = int.parse(userid!);
    transRe.recurrence.userId = int.parse(userid!);
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(Uri.parse(EndPoint.InsertTransactionRecurrence),
        body: jsonEncode(transRe.toJson()), headers: headersValue);
        print(response.statusCode);
    if (response.statusCode == 200) {
      ResponseApi res = new ResponseApi(
          status: response.statusCode, message: 'Success', data: '');
      return res;
    } else {
      ResponseApi res = new ResponseApi(
          status: response.statusCode, message: response.body, data: '');
      return res;
    }
  }

  Future<ResponseApi> DeleteTransRe(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');

    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.delete(
        Uri.parse(EndPoint.DeleteTransactionRecurrence.replaceAll('{id}', id.toString())),
        headers: headersValue);
    if (response.statusCode == 204) {
      ResponseApi res = new ResponseApi(
          status: response.statusCode, message: 'Success', data: '');
      return res;
    } else {
      ResponseApi res = new ResponseApi(
          status: response.statusCode, message: response.body, data: '');
      return res;
    }
  }

  Future<ResponseApi> UpdateTransRe(TransactionRecurrence transRe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');

    transRe.userId = int.parse(userid!);
    transRe.recurrence.userId = int.parse(userid!);
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.put(
        Uri.parse(
            EndPoint.UpdateTransactionRecurrence.replaceAll('{id}', transRe.transactionRecurringId.toString())),
            body: jsonEncode(transRe.toJson()),
        headers: headersValue);
    print(response.statusCode);
    if (response.statusCode == 200) {
      ResponseApi res = new ResponseApi(
          status: response.statusCode, message: 'Success', data: '');
      return res;
    } else {
      ResponseApi res = new ResponseApi(
          status: response.statusCode, message: response.body, data: '');
      return res;
    }
  }

  Future<List<TransRecuResponce>> findRecuActive(ParamPudget param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');

    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    param.userId = int.parse(userid!);
    var bodyValue = jsonEncode(param.toJson());
    final response = await http.post(
        Uri.parse(EndPoint.findRecuActive),
        body: bodyValue,
        headers: headersValue);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      
      List<TransRecuResponce> billList = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          billList.add(TransRecuResponce.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return billList;
    } else {
      return [];
    }
  }

  Future<List<TransRecuResponce>> findRecuExpired(ParamPudget param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');

    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    param.userId = int.parse(userid!);
    var bodyValue = jsonEncode(param.toJson());
    final response = await http.post(
        Uri.parse(EndPoint.findRecuExpired),
        body: bodyValue,
        headers: headersValue);

    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();

      List<TransRecuResponce> billList = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          billList.add(TransRecuResponce.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return billList;
    } else {
      return [];
    }
  }

  Future<TransactionRecurrence> findTransById(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');

    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse(EndPoint.getTransactionsRecurringById.replaceAll('{id}', id.toString())),
        headers: headersValue);
    if (response.statusCode == 200) {
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      TransactionRecurrence bills = TransactionRecurrence.fromJson(parsed);

      return bills;
    } else {
      return TransactionRecurrence(
          transactionRecurringId: 0,
          userId: 0,
          amount: 0,
          recurrence: new Recurrence(
              recurrenceId: 0,
              userId: 0,
              frequency: "frequency",
              every: 0,
              dayOfWeek: "dayOfWeek",
              monthOption: MonthOption.SAMEDAY,
              endType: EndType.FOREVER,
              times: 0,
              timesCompleted: 0,
              startDate: DateTime.now(),
              dueDate: DateTime.now()),
          categoryId: 0,
          walletId: 0, notes: '');
    }
  }
}