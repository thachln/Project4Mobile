import 'package:flutter/material.dart';
import 'package:pj4mb/screens/Account/MyWallet.dart';

import '../Account/Category.dart';

class AddBudgetPage extends StatefulWidget {
  @override
  _AddBudgetPageState createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValueCategory = 'Chọn nhóm';
  String dropDownValueWallet = 'Ví Tiền';
  bool isSwitched = false;
  DateTime selectedDate = DateTime.now();
  final myController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Ngân Sách'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.category),
            title: Text(dropdownValueCategory),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryPage()),
              );

              if (result != null) {
                setState(() {
                  dropdownValueCategory = result;
                });
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: TextField(
              onChanged: (value) {},
              controller: myController,
              decoration: InputDecoration(
                hintText: 'VND',
              ),
              keyboardType: TextInputType.number,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('This Month'),
            subtitle: Text("${selectedDate.toLocal()}".split(' ')[0]),
            onTap: () => _selectDate(context),
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text(dropDownValueWallet),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () async {
              //navigate to WalletPage and await a result
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyWalletPage()), //replace WalletPage with your actual wallet selection page
              );

              //update the selected wallet when a result is returned
              if (result != null) {
                setState(() {
                  dropDownValueWallet = result;
                });
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.repeat),
            title: Text('Repeat This Budget'),
            subtitle: Text('Budget will renew automatically'),
            trailing: Switch(
              value: isSwitched,
              onChanged: (bool value) {
                setState(() {
                  isSwitched = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                isSwitched = !isSwitched;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: ElevatedButton(child: Text("SAVE"), onPressed: () {})),
          ),
        ],
      ),
    );
  }
}
