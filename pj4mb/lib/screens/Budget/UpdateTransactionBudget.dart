import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Transaction/Transaction.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Account/Category.dart';

import 'package:pj4mb/services/Transacsion_service.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class UpdateTransactionBudgetPage extends StatefulWidget {
  const UpdateTransactionBudgetPage({
    super.key,
    required this.trans,
    required this.cate,
  });
  final Transaction trans;
  final CategoryResponse cate;
  @override
  State<UpdateTransactionBudgetPage> createState() => _UpdateTransactionBudgetPageState();
}

class _UpdateTransactionBudgetPageState extends State<UpdateTransactionBudgetPage> {
  int categoryID = 0;
  String categoryName = '';
  DateTime selectedDate = DateTime.now();
  Category? valueCate;
  late int walletID = 0;
  late String walletName = '';
  late Future<List<Wallet>> valueWallet;
  late Future<Category> cate;
  TextEditingController moneyNumber = new TextEditingController();
  TextEditingController noteText = new TextEditingController();
  TextEditingController dateStart = new TextEditingController();
  late Wallet wallet;
  late Future<Transaction> trans;

  @override
  void initState() {
    super.initState();
    valueWallet = WalletService().GetWallet();
    moneyNumber.text = widget.trans.amount.toString();
    noteText.text = widget.trans.notes != null ? widget.trans.notes! : '';
    categoryID = widget.cate.categoryID;
    categoryName = widget.cate.name;
    selectedDate = widget.trans.transactionDate;
    walletID = widget.trans.walletId;
  }

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
        print(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          "Update transaction",
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm?'),
                    content: Text('Are you sure to delete this transaction ?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          var result = await TransactionService()
                              .DeleteTransaction(widget.trans.transactionId);
                          if (result.status == 204) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Information'),
                                  content: Text('Delete success!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
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
                                  title: Text('Information'),
                                  content: Text('Delete fail! ${result.message.toString()}'),
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
                          }
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
            icon: Icon(Icons.delete),
          ),
        ],
      ),
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
                      controller: moneyNumber,
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
                    onTap: () async {
                      valueCate = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                    Type:"InEx",
                                  )));
                      setState(() {
                        if (valueCate != null) {
                          // Update here using the selected category name
                          categoryName = valueCate!.name;
                          categoryID = valueCate!.categoryID;
                        }
                      });
                    },
                    child: categoryName.trim().isEmpty
                        ? Text('Chọn nhóm')
                        : Text(categoryName),
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
                      controller: noteText,
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
                    onTap: () async {
                      await _selectDate(context);
                    },
                    child: Text(DateFormat('dd-MM-yyyy').format(selectedDate)),
                  ))
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Icon(Icons.exposure),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FutureBuilder<List<Wallet>>(
                      future: valueWallet,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Wallet>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          print((widget.trans.walletId.toString()));
                          wallet = snapshot.data!.firstWhere((element) =>
                              element.walletID == widget.trans.walletId);
                          return DropdownButtonFormField<Wallet>(
                            decoration: InputDecoration(
                              hintText: 'Wallet',
                            ),
                            value: wallet,
                            onChanged: (Wallet? value) {
                              setState(() {
                                walletID = value!.walletID;
                                walletName = value!.walletName;
                              });
                            },
                            items: snapshot.data!.map((Wallet value) {
                              return DropdownMenuItem<Wallet>(
                                value: value,
                                child: Text(value.walletName),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  Transaction trans = new Transaction(
                      transactionId: widget.trans.transactionId,
                      userId: widget.trans.userId,
                      walletId: walletID,
                      categoryId: categoryID,
                      amount: double.parse(moneyNumber.text),
                      notes: noteText.text,
                      transactionDate: selectedDate, savingGoalId: 0);
                  var result =
                      await TransactionService().UpdateTransaction(trans);
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
                          content: Text('${result.message}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Update'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
