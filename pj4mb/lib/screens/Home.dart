import 'package:flutter/material.dart';
import 'package:pj4mb/screens/AddTransaction.dart';
import 'package:pj4mb/screens/Overview.dart';
import 'package:pj4mb/screens/TransactionsScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Screens for each tab
  final List<Widget> _children = [
    Overview(), // Tổng quan
    TransactionsScreen(), // Số giao dịch
    Container(), // Placeholder for Button Thêm
    BudgetScreen(), // Ngân sách
    AccountsScreen(), // Tài khoản
  ];

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
            label: 'Tổng quan',
            
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            label: 'Số giao dịch',
          ),
          BottomNavigationBarItem(
              icon: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddTransactionPage()));
                },
                child: Icon(Icons.add, color: Colors.white), 
                backgroundColor: Colors.green, 
                tooltip: 'Thêm giao dịch',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), 
                ),
              ), // Custom icon size for the action button
              label: '',
              ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.pie_chart),
            label: 'Ngân sách',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_balance_wallet),
            label: 'Tài khoản',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}


class BudgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Ngân sách Screen"));
  }
}

class AccountsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Tài khoản Screen"));
  }
}
