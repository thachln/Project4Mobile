import 'package:flutter/material.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/screens/Account/ChangeInfor.dart';
import 'package:pj4mb/screens/Account/ChangePassword.dart';

import 'package:pj4mb/screens/Account/MyWallet.dart';
import 'package:pj4mb/screens/Bill/BillPage.dart';
import 'package:pj4mb/screens/Debt/Debt.dart';
import 'package:pj4mb/screens/Login.dart';
import 'package:pj4mb/screens/SavingGoals/SavingGoalScreen.dart';
import 'package:pj4mb/screens/Transaction_Recurrence/TransRePage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);
  
  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  late SharedPreferences prefs;
  String userName = "";
  String email = "";
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    prefs = await SharedPreferences.getInstance(); 
    setState(() {
      userName = prefs.getString('username') ?? ""; 
      email = prefs.getString('email') ?? "";
    });
  }
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
                      userName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black, 
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  ],
                ),
                onTap: () {},
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(Type: "InEx",)));        
              },
            ),
            ListTile(
              leading: Icon(Icons.document_scanner),
              title: Text("Bill"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BillPage()));        
              },
            ),
            ListTile(
              leading: Icon(Icons.document_scanner),
              title: Text("Transaction Recurrence"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TransRePage()));        
              },
            ),
             ListTile(
              leading: Icon(Icons.credit_card),
              title: Text("Debt"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DebtPage()));        
              },
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text("Saving Goals"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SavingGoalPage()));        
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Change Information"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeInforPage()));        
              },
            ),
             ListTile(
              leading: Icon(Icons.info),
              title: Text("Change Pasword"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));        
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