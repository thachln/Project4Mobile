import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pj4mb/api/endpoint.dart';
import 'package:pj4mb/models/Response.dart';
import 'package:pj4mb/models/User/ChangeInfor.dart';
import 'package:pj4mb/models/User/ChangePasswordWithOTP.dart';
import 'package:pj4mb/models/User/ResetPass.dart';
import 'package:pj4mb/models/User/UpdatePass.dart';
import 'package:pj4mb/models/User/User.dart';
import 'package:pj4mb/screens/Account/ChangePassword.dart';
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
      await prefs.setString('token', parsed['accessToken'].toString());
      await prefs.setString('username', parsed['username'].toString());
      await prefs.setString('email', parsed['email'].toString());
      print(parsed);
      print('Token ne' + prefs.getString('token')!);
      return User.fromJson(parsed);
    } else {
      return new User(id: 0, username: "0", email: "0", password: "0", is_enabled: false, statusCode: response.statusCode.toString(), message: response.body);
    }
  }

  Future<ResponseApi> SignUp(String email, String password,String username,String confirmPassword) async {
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

  Future<ResponseApi> ChangeInformation(ChangeInfor change) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print(change.toJson());
    print(token);
    final response = await http
        .put(Uri.parse(EndPoint.ChangeInformation.replaceAll('{id}', userid!)),body: jsonEncode(change.toJson()),headers: headersValue);
        print(response.statusCode);
        print(response.body);
    if (response.statusCode == 200) {
      return new ResponseApi(status: response.statusCode, message: response.body,data: "parsed");
    }    
    else{
      return new ResponseApi(status: response.statusCode, message: response.body,data: "parsed");
    }
  }

  Future<ResponseApi> UpdatePassword(UpdatePass updatePass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    updatePass.userId = int.parse(userid!);
    final response = await http
        .post(Uri.parse(EndPoint.ChangePass),body: jsonEncode(updatePass.toJson()),headers: headersValue);
        print(response.statusCode);
    if (response.statusCode == 200) {
      return new ResponseApi(status: response.statusCode, message: response.body,data: "parsed");
    }    
    else{
      return new ResponseApi(status: response.statusCode, message: response.body,data: "parsed");
    }
  }

  Future<ResponseApi> ResetPassword(ResetPass resetPass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    resetPass.token = token!;
    final response = await http
        .put(Uri.parse(EndPoint.ResetPass),body: jsonEncode(resetPass.toJson()),headers: headersValue);
        print(response.statusCode);
    if (response.statusCode == 200) {
      return new ResponseApi(status: response.statusCode, message: response.body,data: "parsed");
    }    
    else{
      return new ResponseApi(status: response.statusCode, message: response.body,data: "parsed");
    }
  }

  Future<ResponseApi> ForgotPass(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var bodyValue = jsonEncode({
      'email': email,
    });
    final response = await http
        .post(Uri.parse(EndPoint.ForgotPass),body: bodyValue,headers: headersValue);
        print(response.statusCode);
    if (response.statusCode == 200) {
      return new ResponseApi(status: response.statusCode, message: response.body,data: "parsed");
    }    
    else{
      return new ResponseApi(status: response.statusCode, message: response.body,data: "parsed");
    }
  }

  Future<ResponseApi> ChangePassWithOTP (ChangePasswordWithOTP change) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('userid');
    var token = prefs.getString('token');
     var headersValue = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    
    final response = await http
        .post(Uri.parse(EndPoint.ChangePasswordWithOTP),body: jsonEncode(change.toJson()),headers: headersValue);
        print(response.statusCode);
    if (response.statusCode == 200) {
      return new ResponseApi(status: response.statusCode, message: response.body,data: "parsed");
    }    
    else{
      return new ResponseApi(status: response.statusCode, message: response.body,data: "parsed");
    }
  }
}
