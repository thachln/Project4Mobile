import 'package:flutter/material.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/screens/Account/MyWallet.dart';
import 'package:pj4mb/screens/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);
  
  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                title: Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/welcome_screen.png"),
                    radius: 30,
                  ),
                ),
                subtitle: Column(
                  children: [
                    Text(
                      "tranhoangtu007",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black, // May want to change color to black for better contrast
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "tranhoangtu007@gmail.com",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black, // May want to change color to black for better contrast
                        fontSize: 14,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  ],
                ),
                onTap: () {},
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),

            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text("My Wallet"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyWalletPage(flag: true,)));             
              },
            ),

            ListTile(
              leading: Icon(Icons.group),
              title: Text("Group"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(flag: true,)));        
              },
            ),
             ListTile(
              leading: Icon(Icons.logout),
              title: Text("Log out"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Warning'),
                        content: Text('You really want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('userid','');
                              prefs.setString('token','');
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                            },
                            child: Text('OK'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancle'),
                          ),
                        ],
                      );
                    },
                  );        
              },
            ),
            
            // Your other ListTiles go here
          ],
        ),
      ),
    );
  }
}