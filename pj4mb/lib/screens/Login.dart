import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/screens/Home.dart';

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
              onPressed: () {

                if(email.text == '123@gmail.com' && password.text == '123')
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
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
                    onTap: () {},
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
