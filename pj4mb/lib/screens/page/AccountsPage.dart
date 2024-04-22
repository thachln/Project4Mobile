import 'package:flutter/material.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);
  
  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change background color to white
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                title: Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/img/onedrive_logo.png"),
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
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.group),
              title: Text("Group"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            
            // Your other ListTiles go here
          ],
        ),
      ),
    );
  }
}