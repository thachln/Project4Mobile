import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/screens/AddTransaction/Group.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController moneyNumber = new TextEditingController();
    TextEditingController groupNumber = new TextEditingController();
    TextEditingController noteText = new TextEditingController();
    TextEditingController dateStart = new TextEditingController();
    TextEditingController walletType = new TextEditingController();
    DateTime selectedDate = DateTime.now();

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          print("Ngày sau khi setState: $selectedDate");
        });
      }
    }

    return Scaffold(
      //backgroundColor: Colors.black87,
      appBar: AppBar(
          title: Text(
        "Add new transaction",
      )),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        //color :Colors.grey[500],
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.monetization_on_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Icon(Icons.question_mark_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TransactionAdd_GroupPage()));
                    },
                    child: Text(
                      'Chọn nhóm',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ))
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Icon(Icons.notes),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Thêm ghi chú'),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Icon(Icons.calendar_month_sharp),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                  ))
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Icon(Icons.account_balance_wallet_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () {},
                    child: Text('Tiền mặt'),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
