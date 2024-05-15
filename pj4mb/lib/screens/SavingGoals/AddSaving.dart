import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Bill/EndType.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/SavingGoal/EndDateType.dart';
import 'package:pj4mb/models/SavingGoal/SavingGoal.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/services/SavingGoal_service.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class AddSavingPage extends StatefulWidget {
  const AddSavingPage({super.key});

  @override
  State<AddSavingPage> createState() => _AddSavingPageState();
}

class _AddSavingPageState extends State<AddSavingPage> {
  //EditController
  TextEditingController goalName = TextEditingController();
  TextEditingController targetAmount = TextEditingController();
  TextEditingController currentAmount = TextEditingController();
  //

  //Model
  Category? valueCate;
  //

  //variable
  late Future<List<Wallet>> valueWallet;
  late int walletID = 0;
  late String walletName = '';

  DateTime selectedFromDate = DateTime.now();
  DateTime? selectedToDate;

  //

  //Enum
  EndDateType endDateType = EndDateType.FOREVER;
  //

  //Function
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedFromDate) {
      setState(() {
        selectedFromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: selectedFromDate,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedToDate) {
      setState(() {
        selectedToDate = picked;
      });
    }
  }
  //

  @override
  void initState() {
    super.initState();
    valueWallet = WalletService().GetWallet();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<EndDateType>> dropdownItemsEndDateType =
        EndDateType.values
            .map((endDateType) => DropdownMenuItem<EndDateType>(
                  value: endDateType,
                  child: Text(endDateType.toString().split('.').last),
                ))
            .toList();

    return Scaffold(
      //backgroundColor: Colors.black87,
      appBar: AppBar(
          title: Text(
        "Add new saving",
      )),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.abc),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: goalName,
                        keyboardType: TextInputType.text,
                        decoration:
                            InputDecoration(hintText: 'Saving goal name'),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(Icons.monetization_on_rounded),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: targetAmount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Target amount'),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(Icons.monetization_on_rounded),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: currentAmount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Current amount'),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(Icons.wallet),
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
                            List<Wallet> walletGoal = snapshot.data!
                                .where((element) => element.walletTypeID == 3)
                                .toList();
                            return DropdownButtonFormField<Wallet>(
                              decoration: InputDecoration(
                                hintText: 'Wallet',
                              ),
                              value: null,
                              onChanged: (Wallet? value) {
                                setState(() {
                                  walletID = value!.walletID;
                                  walletName = value!.walletName;
                                });
                              },
                              items: walletGoal.map((Wallet value) {
                                return DropdownMenuItem<Wallet>(
                                  value: value,
                                  child: Text(value.walletName),
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    // Icon(Icons.calendar_month_sharp),
                    Text('From Date: '),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        //await _selectFromDate(context);
                      },
                      child: Text(
                          DateFormat('dd-MM-yyyy').format(selectedFromDate)),
                    ))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('Ending Date: '),
                    DropdownButton<EndDateType>(
                      value: endDateType,
                      onChanged: (EndDateType? newValue) {
                        setState(() {
                          endDateType = newValue!;
                        });
                      },
                      items: dropdownItemsEndDateType,
                    )
                  ],
                ),
                if (endDateType == EndDateType.END_DATE)
                  Container(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          // Icon(Icons.calendar_month_sharp),
                          Text('To Date: '),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: InkWell(
                            onTap: () async {
                              await _selectToDate(context);
                            },
                            child: selectedToDate != null
                                ? Text(DateFormat('dd-MM-yyyy')
                                    .format(selectedToDate!))
                                : Text('Select date'),
                          ))
                        ],
                      ),
                    ],
                  )),
                ElevatedButton(
                  onPressed: () async {
                    //Validate
                    if (goalName.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alret'),
                            content: Text('Goal name is required!'),
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
                    if (walletID == 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alret'),
                            content: Text('Wallet is required!'),
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
                    if (selectedFromDate
                        .isBefore(DateTime.now().subtract(Duration(days: 1)))) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alret'),
                            content:
                                Text('From date must be greater than today!'),
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
                    if (endDateType == EndDateType.END_DATE) {
                      if (selectedToDate == null ||
                          (selectedToDate != null &&
                              selectedToDate!.isBefore(selectedFromDate))) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alret'),
                              content: Text(
                                  'To date must be greater than from date!'),
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
                    }
                    if(currentAmount.text.isEmpty){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alret'),
                            content: Text('Current amount is required!'),
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
                    if(targetAmount.text.isEmpty){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alret'),
                            content: Text('Target amount is required!'),
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
                    if(double.parse(targetAmount.text) < 0)
                    {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alret'),
                            content: Text('Target amount must be greater than or equal to 0!'),
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
                    if(double.parse(currentAmount.text) > double.parse(targetAmount.text)){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alret'),
                            content: Text('Current amount must be less than target amount!'),
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
                    SavingGoal savingGoal = SavingGoal(
                        id: 0,
                        name: goalName.text,
                        targetAmount: double.parse(targetAmount.text),
                        currentAmount: double.parse(currentAmount.text),
                        startDate: selectedFromDate,
                        endDate: selectedToDate,
                        endDateType: endDateType,
                        userId: 0,
                        walletId: walletID);
                    var result =
                        await SavingGoalService().CreateSavingGoal(savingGoal);
                    if (result.status == 201) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alret'),
                            content: Text('Add saving goal success!'),
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
                            title: Text('Alret'),
                            content: Text('Add saving goal failed!'),
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
