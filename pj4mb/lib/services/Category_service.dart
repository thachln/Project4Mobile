import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Category/Cat_Icon.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  Future<List<Category>> GetCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    final response = await http
        .get(Uri.parse(EndPoint.GetCategory.replaceAll("{userId}", userid!)));
    //print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
      List<Category> categories = [];
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          categories.add(Category.fromJson(item));
        } else {
          throw Exception('Invalid item format');
        }
      }
      return categories;
    } else {
      return [];
    }
  }

  Future<bool> InsertCategory(Category category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    category.user = int.parse(userid!);
   
    final response = await http
        .post(Uri.parse(EndPoint.InsertCategory), body: jsonEncode(category.toJson()),headers: {
          'Content-Type': 'application/json',
        });
   
    if (response.statusCode == 201) {
      return true;
    }    
    else{
      return false;
    }
  }
  Future<bool> updateCategory(Category category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    category.user = int.parse(userid!);
   
    final response = await http
        .put(Uri.parse(EndPoint.GetCategory.replaceAll("{userId}", userid)), body: jsonEncode(category.toJson()),headers: {
          'Content-Type': 'application/json',
        });
   
    if (response.statusCode == 201) {
      return true;
    }    
    else{
      return false;
    }
  }
  Future<List<Cat_Icon>> GetIcon() async {

    final response = await http
        .get(Uri.parse(EndPoint.GetIcon));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).map((e) => Cat_Icon.fromJson(e)).toList();
    }    
    else{
      throw Exception(response.body);
    }
  }
}
