import 'package:flutter/material.dart';
import 'package:pj4mb/screens/Account/AccountsPage.dart';
import 'package:pj4mb/screens/Budget/BudgetPage.dart';

import 'package:pj4mb/screens/Overview.dart';
import 'package:pj4mb/screens/Transaction/AddTransaction.dart';
import 'package:pj4mb/screens/Transaction/TransactionsScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  
  // Screens for each tab
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      Overview(), // Tổng quan
      TransactionsScreen(), // Số giao dịch
      Container(), // Placeholder for Button Thêm
      BudgetPage(), // Ngân sách
      AccountsPage(), // Tài khoản
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: Colors.black87,
        unselectedItemColor: Colors.grey[700],
        selectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: new Icon(Icons.home),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: FloatingActionButton(
              onPressed: () async {
                onTabTapped(2);
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTransactionPage()));  
                onTabTapped(1);            
              },
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.green,
              tooltip: 'Add transaction',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ), // Custom icon size for the action button
            label: '',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.pie_chart),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_balance_wallet),
            label: 'Account',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
