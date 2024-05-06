import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/User/ChangeInfor.dart';
import 'package:pj4mb/models/User/UpdatePass.dart';
import 'package:pj4mb/services/Login_service.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController oldPassword = TextEditingController();
    TextEditingController newPassword = TextEditingController();
    TextEditingController confirmNewPassword = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: email,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: oldPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Old Password',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: newPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'New Password',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: confirmNewPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Confirm Password',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              UpdatePass change = new UpdatePass(userId: 0, email: email.text, oldPassword: oldPassword.text, newPassword: newPassword.text, confirmNewPassword: confirmNewPassword.text);
              var result = await LoginService().UpdatePassword(change);
              if (result.status == 200) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Thông báo'),
                        content: Text('Update success!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                              Navigator.pop(context, true);
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
                        content: Text('Update fail! ${result.message}'),
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
              },
            child: Text('Change Password'),
          ),
        ),
      ],),
    );
  }
}