import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pj4mb/screens/Login.dart';
import 'package:pj4mb/services/Login_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _LoginNextPageState();
}

class _LoginNextPageState extends State<SignUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isObscure = true;
  bool _isProcessing = false;

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(children: [
            SizedBox(height: 60),
            Text('Sign Up'),
            TextField(
              controller: username,
              decoration: InputDecoration(hintText: 'Username'),
              keyboardType: TextInputType.text,
            ),
            TextField(
                controller: email,
                decoration: InputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp('[ ]')), 
                ]),
            TextField(
              controller: password,
              obscureText: _isObscure, 
              decoration: InputDecoration(
                hintText: 'Password', 
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
            ),
            TextField(
              controller: confirmPassword,
              obscureText: _isObscure, 
              decoration: InputDecoration(
                hintText: 'Confirm Password', 
                suffixIcon: IconButton(
                  icon: Icon(   
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {       
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
                  buildShowDialog(context);
                  var result = await LoginService().SignUp(email.text,
                      password.text, username.text, confirmPassword.text);
                  Navigator.of(context).pop();
                  print(result.status);
                  if (result.status == 200) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Thông báo'),
                          content: Text(result.message),
                          actions: [
                            TextButton(
                              onPressed: () {},
                              child: Text('Resend'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                        (route) => false,);
                              },
                              child: Text('Confirmed, go to Login page'),
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
                          content: Text(result.message),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Text('Đăng ký'),
              ),
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            }, child: Text('Đăng nhập'))
          ]),
        ),
      ),
    );
  }
}
