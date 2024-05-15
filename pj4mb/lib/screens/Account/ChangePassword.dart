import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/User/ChangeInfor.dart';
import 'package:pj4mb/models/User/ChangePasswordWithOTP.dart';
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
    TextEditingController otp = TextEditingController();
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Column(
        children: [
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
                buildShowDialog(context);
                UpdatePass change = new UpdatePass(
                    userId: 0,
                    email: email.text,
                    oldPassword: oldPassword.text,
                    newPassword: newPassword.text,
                    confirmNewPassword: confirmNewPassword.text);
                var result = await LoginService().UpdatePassword(change);
                Navigator.of(context).pop();
                if (result.status == 200) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Please check your email and enter OTP code'),
                        content: TextField(
                          controller: otp,
                          decoration: const InputDecoration(
                              hintText: "OTP"),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              buildShowDialog(context);
                              ChangePasswordWithOTP changeOTP = new ChangePasswordWithOTP(
                                  passwordDTO: change,
                                  verifyOTPDTO: new VerifyOTPDTO(
                                      email: email.text, pin: otp.text));
                              var resultOTP = await LoginService().ChangePassWithOTP(changeOTP);
                              Navigator.of(context).pop();
                              if(resultOTP.status == 200){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Arlet'),
                                      content: Text('Update success!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              else{
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Arlet'),
                                      content: Text('Update fail! ${resultOTP.message}'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK2'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }                         
                            },
                            child: Text('OK'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                              Navigator.pop(context, true);
                            },
                            child: Text('Cancle'),
                          ),
                        ],
                      );
                    },
                  );
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return AlertDialog(
                  //       title: Text('Arlet'),
                  //       content: Text('Update success!'),
                  //       actions: [
                  //         TextButton(
                  //           onPressed: () {
                  //             Navigator.pop(context, true);
                  //             Navigator.pop(context, true);
                  //           },
                  //           child: Text('OK'),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
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
        ],
      ),
    );
  }
}
