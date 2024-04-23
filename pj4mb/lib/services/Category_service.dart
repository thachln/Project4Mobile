import 'dart:convert';

import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  Future<List<Category>> GetCategory(String userId) async {
    final response = await http
        .get(Uri.parse(EndPoint.GetCategory.replaceAll("{userId}", userId)));
    //print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      //return parsed.map((e) => Category.fromJson(e)).toList();
      List<Category> categories = [];
      var count = 0;
      for (var item in parsed) {
        if (item is Map<String, dynamic>) {
          count++;
          categories.add(Category.fromJson(item));
           print(count);
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
