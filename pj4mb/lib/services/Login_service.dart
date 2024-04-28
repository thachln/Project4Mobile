import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Response.dart';
import 'package:pj4mb/models/User/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  Future<User> login(String email, String password) async {
    final response = await http.post(Uri.parse(EndPoint.SignIn),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        });
    if (response.statusCode == 200) {     
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userid', parsed['id'].toString());
      return User.fromJson(parsed);
    } else {
      return new User(id: 0, username: "0", email: "0", password: "0", is_enabled: false, statusCode: response.statusCode.toString(), message: response.body);
    }
  }

  Future<ResponseApi> SignUp(String email, String password,String username,String confirmPassword) async {
    print(jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'confirmPassword':confirmPassword
        }));
    final response = await http.post(Uri.parse(EndPoint.SignUp),
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'confirmPassword':confirmPassword
        }),
        headers: {
          'Content-Type': 'application/json',
        });
        print(response.statusCode);
    if (response.statusCode == 200) {     
      return new ResponseApi(status: response.statusCode, message: response.body,data: "parsed");
    } else {
      return new ResponseApi(status: response.statusCode, message: response.body,data: "parsed");
    }
  }
}
