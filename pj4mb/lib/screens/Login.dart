import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/screens/Home.dart';
import 'package:pj4mb/screens/SignUp.dart';
import 'package:pj4mb/services/Login_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(children: [
          SizedBox(height: 60),
          Text('Login'),
          TextField(
              controller: email,
              decoration: InputDecoration(hintText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp('[ ]')), // Không cho phép khoảng trắng
              ]),
          TextField(
            controller: password,
            obscureText: _isObscure, // Sử dụng biến để ẩn/hiện mật khẩu
            decoration: InputDecoration(
              hintText: 'Password', // Placeholder là 'Password'
              suffixIcon: IconButton(
                icon: Icon(
                  // Chọn icon tương ứng với trạng thái ẩn/hiện
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  // Cập nhật trạng thái và gọi setState để cập nhật giao diện
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (email.text == '' || password.text == '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Thông báo'),
                        content: Text('Vui lòng nhập đầy đủ thông tin'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                } else {
                  var user =
                      await LoginService().login(email.text, password.text);
                  print(user);
                  if (user.is_enabled == true) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } else if (user.statusCode == '401') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Thông báo'),
                          content: Text(user.message),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (!user.is_enabled) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Thông báo'),
                          content: Text('Tài khoản của bạn chưa xác thực'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Thông báo'),
                          content: Text(
                              'Error: ${user.statusCode} - ${user.message}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: Text('Đăng nhập'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Text('Đăng ký'),
              ),
              InkWell(
                onTap: () {},
                child: Text('Quên mật khẩu'),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
