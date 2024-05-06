import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Bill/Bill.dart';
import 'package:pj4mb/models/Bill/BillResponse.dart';
import 'package:pj4mb/models/Bill/EndType.dart';
import 'package:pj4mb/models/Bill/MonthOption.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/Response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BillService {
  Future<ResponseApi> InsertBill(Bill bill) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    bill.userId = int.parse(userid!);
    bill.recurrence.userId = int.parse(userid!);
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(Uri.parse(EndPoint.InsertBill),
        body: jsonEncode(bill.toJson()), headers: headersValue);
    if (response.statusCode == 201) {
      ResponseApi res = new ResponseApi(
          status: response.statusCode, message: 'Success', data: '');
      return res;
    } else {
      ResponseApi res = new ResponseApi(
          status: response.statusCode, message: response.body, data: '');
      return res;
    }
  }

  Future<ResponseApi> DeleteBill(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');

    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.delete(
        Uri.parse(EndPoint.DeleteBill.replaceAll('{id}', id.toString())),
        headers: headersValue);
        print(response.statusCode);
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

  Future<ResponseApi> UpdateBill(Bill bill) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');

    bill.userId = int.parse(userid!);
    bill.recurrence.userId = int.parse(userid!);
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.put(
        Uri.parse(
            EndPoint.UpdateBill.replaceAll('{id}', bill.billId.toString())),
            body: jsonEncode(bill.toJson()),
        headers: headersValue);
    print(response.statusCode);
    if (response.statusCode == 201) {
      ResponseApi res = new ResponseApi(
          status: response.statusCode, message: 'Success', data: '');
      return res;
    } else {
      ResponseApi res = new ResponseApi(
          status: response.statusCode, message: response.body, data: '');
      return res;
    }
  }

  Future<List<BillResponse>> findBillActive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');

    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse(EndPoint.findBillActive.replaceAll('{id}', userid!)),
        headers: headersValue);

    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);

      List<BillResponse> billList = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          billList.add(BillResponse.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return billList;
    } else {
      return [];
    }
  }

  Future<Bill> findBillById(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');

    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse(EndPoint.findBillWithId.replaceAll('{id}', id.toString())),
        headers: headersValue);

    if (response.statusCode == 200) {
      final Map<String, dynamic> parsed = jsonDecode(response.body);

      Bill bills = Bill.fromJson(parsed);
      print(bills.toJson());
      return bills;
    } else {
      return Bill(
          billId: 0,
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
          walletId: 0);
    }
  }

  Future<List<BillResponse>> findBillExpired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');

    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse(EndPoint.findBillExpired.replaceAll('{id}', userid!)),
        headers: headersValue);

    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();

      List<BillResponse> billList = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          billList.add(BillResponse.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return billList;
    } else {
      return [];
    }
  }
}
