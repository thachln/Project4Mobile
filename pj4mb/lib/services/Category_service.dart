import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Category/Cat_Icon.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  Future<List<Category>> GetCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    
    final response = await http
        .get(Uri.parse(EndPoint.GetCategory.replaceAll("{userId}", userid!)),headers: headersValue);
    print(response.body);
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

  Future<CategoryResponse> GetCategoryWithId(int categoryID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    
    final response = await http
        .get(Uri.parse(EndPoint.GetCategoryWithId.replaceAll("{categoryId}", categoryID.toString())),headers: headersValue);
    print(response.body);
    if (response.statusCode == 200) {

      final Map<String, dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
     CategoryResponse category = CategoryResponse.fromJson(parsed);
      
      
      return category;
    } else {
      return CategoryResponse(categoryID: 0, name: '', CategoryType: CateTypeENum.EXPENSE, icon: '', user: 0);
    }
  }

  Future<bool> InsertCategory(Category category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
    category.user = int.parse(userid!);
   var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .post(Uri.parse(EndPoint.InsertCategory), body: jsonEncode(category.toJson()),headers: headersValue);
   
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
    var token = prefs.getString('token');
    category.user = int.parse(userid!);
   var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .put(Uri.parse(EndPoint.GetCategory.replaceAll("{userId}", userid)), body: jsonEncode(category.toJson()),headers: headersValue);
   
    if (response.statusCode == 201) {
      return true;
    }    
    else{
      return false;
    }
  }

  Future<bool> DeleteCategory(int categoryID) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .delete(Uri.parse(EndPoint.DeleteCategory.replaceAll("{categoryID}", categoryID.toString())),headers: headersValue);
    if (response.statusCode == 200) {
      return true;
    }    
    else{
      return false;
    }
  }
  Future<List<Cat_Icon>> GetIcon() async {
 SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .get(Uri.parse(EndPoint.GetIcon),headers: headersValue);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).map((e) => Cat_Icon.fromJson(e)).toList();
    }    
    else{
      throw Exception(response.body);
    }
  }
}
