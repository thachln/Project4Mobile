import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/SavingGoal/SavingGoal.dart';
import 'package:pj4mb/models/SavingGoal/TransactionWithSaving.dart';
import 'package:pj4mb/models/Transaction/Transaction.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/screens/ThousandsSeparatorInputFormatter.dart';
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/services/SavingGoal_service.dart';
import 'package:pj4mb/services/Transacsion_service.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class UpdateTransactionPage extends StatefulWidget {
  const UpdateTransactionPage({
    super.key,
    required this.trans,
    required this.cate, required this.walletTypeCurrent
  });
  final Transaction trans;
  final CategoryResponse cate;
  final int walletTypeCurrent;
  @override
  State<UpdateTransactionPage> createState() => _UpdateTransactionPageState();
}

class _UpdateTransactionPageState extends State<UpdateTransactionPage> {
  int categoryID = 0;
  String categoryName = '';
  DateTime selectedDate = DateTime.now();
  Category? valueCate;
  late int walletID = 0;
  late String walletName = '';
  late Future<List<Wallet>> valueWallet;
  late Future<Category> cate;
  late Future<List<SavingGoal>> listSaving;
  late List<SavingGoal> saving = [];
  late SavingGoal? selectedSaving = null;
  late int walletTypeId;
  late int goalId = 0;
  TextEditingController moneyNumber = new TextEditingController();
  TextEditingController noteText = new TextEditingController();
  TextEditingController dateStart = new TextEditingController();
  late List<Wallet> listWallet;
  late Wallet wallet;
  late Future<Transaction> trans;
  late int? savingGoalId;
  late SavingGoal goal;
  @override
  void initState() {
    super.initState();
    valueWallet = WalletService().GetWallet();
    moneyNumber.text = NumberFormat('#,##0','en_US').format(widget.trans.amount);
    noteText.text = widget.trans.notes != null ? widget.trans.notes! : '';
    categoryID = widget.cate.categoryID;
    categoryName = widget.cate.name;
    selectedDate = widget.trans.transactionDate;
    walletID = widget.trans.walletId;
    savingGoalId = widget.trans.savingGoalId;
    listSaving = SavingGoalService().GetSavingWithWallet(widget.trans.walletId);
    walletTypeId = widget.walletTypeCurrent;

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

  void setWalletType(int walletTypeId) {
    setState(() {
      this.walletTypeId = walletTypeId;
    });
  }

  void loadSaving(int walletId) async {
    var result = await SavingGoalService().GetSavingWithWallet(walletId);
    setState(() {
      saving = result;
    });
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
        margin: EdgeInsets.all(12),
        //color :Colors.grey[500],
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        
                          listWallet = snapshot.data!;
                          wallet = listWallet.firstWhere((element) => element.walletID == widget.trans.walletId,orElse: null);
                          return TextField(
                            readOnly: true,
                            controller: TextEditingController(text: wallet.walletName),
                          );
                          
                        }
                      },
                    ),
                  )
                ],
              ),
              if(walletTypeId == 3)...[
                  SizedBox(height: 25,),
                  FutureBuilder<List<SavingGoal>>(
                      future: listSaving,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<SavingGoal>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          selectedSaving = snapshot.data!.firstWhere((element) => element.id == widget.trans.savingGoalId);
                          goalId = selectedSaving!.id;
                          return TextField(
                            readOnly: true,
                            controller: TextEditingController(text: selectedSaving!.name),
                          );
                         
                        }
                      },
                    ),
                  
                ],
              SizedBox(height: 25,),
              Row(
                children: [
                  Icon(Icons.monetization_on_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                       inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                        LengthLimitingTextInputFormatter(14)
                      ],
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
                                    Type:"InExChoose",
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
                      maxLength: 100,
                      maxLines: 3,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Note'),
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
              
              ElevatedButton(
                onPressed: () async {
                  if(walletID == 0){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alert'),
                            content: Text('Please select wallet!'),
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
                      return;
                    }
                    if(categoryID == 0){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alert'),
                            content: Text('Please select category!'),
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
                      return;
                    }
                    if(moneyNumber.text.isEmpty){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alert'),
                            content: Text('Please enter money!'),
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
                      return;
                    }
                    if(double.parse(moneyNumber.text.replaceAll(',', '')) <= 0){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alert'),
                            content: Text('Money must be greater than 0!'),
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
                      return;
                    }
                  Transaction trans = new Transaction(
                      transactionId: widget.trans.transactionId,
                      userId: widget.trans.userId,
                      walletId: walletID,
                      categoryId: categoryID,
                      amount: double.parse(moneyNumber.text.replaceAll(',', '')),
                      notes: noteText.text,
                      transactionDate: selectedDate, savingGoalId: goalId);
                  var result =
                      await TransactionService().UpdateTransaction(trans);
                  if (result.status == 200) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Arlet'),
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
                          title: Text('Arlet'),
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
