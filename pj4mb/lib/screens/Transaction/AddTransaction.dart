import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/SavingGoal/SavingGoal.dart';
import 'package:pj4mb/models/Transaction/Transaction.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/screens/ThousandsSeparatorInputFormatter.dart';
import 'package:pj4mb/services/SavingGoal_service.dart';
import 'package:pj4mb/services/Transacsion_service.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  int categoryID = 0;
  String categoryName = '';
  DateTime selectedDate = DateTime.now();
  Category? valueCate;
  bool hasSelectedCategory = false;
  late int walletID = 0;
  late int walletTypeId = 0;
  late int goalId = 0;
  late String walletName = '';
  late String walletCurrency = '';
  late Future<List<Wallet>> valueWallet;
  late Future<List<Wallet>> listWallet;
  late List<SavingGoal> listSaving = [];
  TextEditingController moneyNumber = TextEditingController();
  TextEditingController noteText = TextEditingController();
  TextEditingController dateStart = TextEditingController();
  TextEditingController walletType = TextEditingController();

  @override
  void initState() {
    super.initState();

    valueWallet = WalletService().GetWallet();
    listWallet = valueWallet;
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
        print("Ngày sau khi setState: $selectedDate");
      });
    }
  }

  void loadSaving(int walletId) async {
    var result = await SavingGoalService().GetSavingWithWallet(walletId);
    setState(() {
      listSaving = result;
    });
  }
  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                            return DropdownButtonFormField<Wallet>(
                              onTap: () {
                                
                              },
                              decoration: InputDecoration(
                                hintText: 'Wallet',
                              ),
                              value: null,
                              onChanged: (Wallet? value) {
                                if(value!.walletTypeID == 3)
                                {
                                  
                                  loadSaving(value.walletID);
                                }
                                setState(() {
                                  walletID = value!.walletID;
                                  walletName = value.walletName;
                                  walletTypeId = value.walletTypeID;
                                  walletCurrency = value.currency;
                                });
                              },
                              items: snapshot.data!.map((Wallet value) {
                                return DropdownMenuItem<Wallet>(
                                  value: value,
                                  child: Text(value.walletName +  " - " + value.walletTypeID.toString()),
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
                if(walletTypeId == 3)...[
                  SizedBox(height: 25,),
                  DropdownButtonFormField<SavingGoal>(
                              decoration: InputDecoration(
                                hintText: 'Select goal',
                              ),
                              value: null,
                              onChanged: (SavingGoal? value) {
                                setState(() {
                                  goalId = value!.id;
                                });
                              },
                              items: listSaving.map((SavingGoal value) {
                                return DropdownMenuItem<SavingGoal>(
                                  value: value,
                                  child: Text(value.name),
                                );
                              }).toList(),
                            )
                ],
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Icon(Icons.category),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        if(walletID == 0){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Alert'),
                                content: Text('Please select wallet first!'),
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
                        if(walletID != 3)
                        {
                          if(walletCurrency == "USD")
                          {
                            valueCate = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                    Type:"In",
                                  )));
                          }
                          else{
                            valueCate = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                    Type:"InExChoose",
                                  )));
                          }
                          
                        }
                        else{
                          valueCate = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                    Type:"Goal",
                                  )));
                        }
                        setState(() {
                           categoryName = valueCate!.name;
                            categoryID = valueCate!.categoryID;                       
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
                    Icon(Icons.notes),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: noteText,
                        maxLines: 3,
                        maxLength: 100,
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
                        transactionId: 0,
                        userId: 0,
                        walletId: walletID,
                        categoryId: categoryID,
                        amount: double.parse(moneyNumber.text.replaceAll(',', '')),
                        notes: noteText.text,
                        transactionDate: selectedDate, savingGoalId: goalId == 0 ? null : goalId);
                    var result =
                        await TransactionService().InsertTransaction(trans);
                    if (result) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alert'),
                            content: Text('Insert success!'),
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
                            title: Text('Alert'),
                            content: Text('Error: Insert fail!'),
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
                  child: Text('Save'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
