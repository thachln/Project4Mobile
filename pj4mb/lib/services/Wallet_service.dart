import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:http/http.dart' as http;
class WalletService {
  
  Future<List<Wallet>> GetWallet(String userId) async {
    final response = await http.get(Uri.parse(EndPoint.GetWallet.replaceAll("{userId}", userId)));
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
}