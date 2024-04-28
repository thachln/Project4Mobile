import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:http/http.dart' as http;
import 'package:pj4mb/models/Wallet/WalletType.dart';
import 'package:shared_preferences/shared_preferences.dart';
class WalletService {
  
  Future<List<Wallet>> GetWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    final response = await http.get(Uri.parse(EndPoint.GetWallet.replaceAll("{userId}", userid!)));
    //print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
      List<Wallet> categories = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          categories.add(Wallet.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return categories;
    } else {
      return [];
    }
  }

  Future<List<WalletType>> GetWalletType() async {
    final response = await http.get(Uri.parse(EndPoint.GetWalletType));
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      List<WalletType> walletType = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          walletType.add(WalletType.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return walletType;
    } else {
      return [];
    }
  }

  Future<bool> InsertWallet(Wallet wallet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    wallet.userId = int.parse(userid!);
    print(wallet.toJson());
    final response = await http.post(Uri.parse(EndPoint.InsertWallet),body: jsonEncode(wallet.toJson()),headers: {
      'Content-Type': 'application/json',
    });
    print(response.statusCode);
    if (response.statusCode == 201) {     
      return true;
    } else {
      return false;
    }
  }
  Future<bool> UpdateWallet(Wallet wallet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    wallet.userId = int.parse(userid!);
    print(wallet.toJson());
    final response = await http.put(Uri.parse(EndPoint.UpdateWallet.replaceAll("{walletID}", wallet.walletID.toString())),body: jsonEncode(wallet.toJson()),headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {     
      return true;
    } else {
      return false;
    }
  }

  Future<bool> DeleteWallet(int walletID) async {
    final response = await http.delete(Uri.parse(EndPoint.DeleteWallet.replaceAll("{walletID}", walletID.toString())),headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {     
      return true;
    } else {
      return false;
    }
  }

  Future<WalletType> GetWalletTypeWithID(int id) async  {
    final response = await http.get(Uri.parse(EndPoint.GetWalletTypeWithID.replaceAll("{typeID}", id.toString())));
    if (response.statusCode == 200) {
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      return WalletType.fromJson(parsed);
    } else {
      return new WalletType(TypeID: 0, TypeName: "0");
    }
    
  }
}