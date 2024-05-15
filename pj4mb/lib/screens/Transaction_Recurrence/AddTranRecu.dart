import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Bill/Bill.dart';
import 'package:pj4mb/models/Bill/DayOfWeeks.dart';
import 'package:pj4mb/models/Bill/EndType.dart';
import 'package:pj4mb/models/Bill/FrequencyType.dart';
import 'package:pj4mb/models/Bill/MonthOption.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/TransactionRecurrence/TransactionRecurrence.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/screens/ThousandsSeparatorInputFormatter.dart';
import 'package:pj4mb/services/Bill_service.dart';
import 'package:pj4mb/services/TransactionRecurrence_service.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class AddTranRecuPage extends StatefulWidget {
  const AddTranRecuPage({super.key});

  @override
  State<AddTranRecuPage> createState() => _AddTranRecuPageState();
}

class _AddTranRecuPageState extends State<AddTranRecuPage> {
  //EditController
  TextEditingController moneyNumber = new TextEditingController();
  TextEditingController everyDailyNumber = new TextEditingController();
  TextEditingController timeNumber = new TextEditingController();
  //

  //Model
  Category? valueCate;
  //

  //variable
  late Future<List<Wallet>> valueWallet;
  late int walletID = 0;
  late String walletName = '';
  int categoryID = 0;
  String categoryName = '';
  DateTime selectedFromDate = DateTime.now();
  DateTime? selectedToDate;
  late String walletCurrency = '';
  final List<String> days = [
    'MONDAY',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  String? selectedDay = 'Monday';
  //

  //Enum
  FrequencyType frequencyType = FrequencyType.DAILY;
  EndType endType = EndType.FOREVER;
  MonthOption monthOption = MonthOption.SAMEDAY;
  DayOfWeek dayOfWeek = DayOfWeek.MONDAY;
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
      firstDate: DateTime(2000),
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
    valueWallet = WalletService().GetWalletVND();
    timeNumber.text = "0";
    everyDailyNumber.text = "0";
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<FrequencyType>> dropdownItems = FrequencyType.values
        .map((frequencyType) => DropdownMenuItem<FrequencyType>(
              value: frequencyType,
              child: Text(frequencyType.toString().split('.').last),
            ))
        .toList();

    List<DropdownMenuItem<EndType>> dropdownItemsEnd = EndType.values
        .map((endType) => DropdownMenuItem<EndType>(
              value: endType,
              child: Text(endType.toString().split('.').last),
            ))
        .toList();

    List<DropdownMenuItem<MonthOption>> dropdownItemsMonth = MonthOption.values
        .map((month) => DropdownMenuItem<MonthOption>(
              value: month,
              child: Text(month.toString().split('.').last),
            ))
        .toList();

    List<DropdownMenuItem<DayOfWeek>> dropdownItemsDayOfWeeks = DayOfWeek.values
        .map((dayofweeks) => DropdownMenuItem<DayOfWeek>(
              value: dayofweeks,
              child: Text(dayofweeks.toString().split('.').last),
            ))
        .toList();

    return Scaffold(
      //backgroundColor: Colors.black87,
      appBar: AppBar(
          title: Text(
        "Add new transaction recurrence",
      )),
      body: Container(
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
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Money'),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
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
                          return DropdownButtonFormField<Wallet>(
                            decoration: InputDecoration(
                              hintText: 'Wallet',
                            ),
                            value: null,
                            onChanged: (Wallet? value) {
                              setState(() {
                                walletID = value!.walletID;
                                walletName = value!.walletName;
                                categoryID = 0;
                                categoryName = '';
                                walletCurrency = value!.currency;
                              });
                            },
                            items: snapshot.data!
                                .where((element) => element.walletTypeID != 3)
                                .map((Wallet value) {
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
                height: 20,
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
                      if (walletID == 0) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alret'),
                              content: Text('Please choose wallet first!'),
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
                      if (walletCurrency.isNotEmpty &&
                          walletCurrency == 'VND') {
                        valueCate = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryPage(
                                      Type: "InExChoose",
                                    )));
                      } else {
                        valueCate = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryPage(
                                      Type: "In",
                                    )));
                      }

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
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Text('Frequency: '),
                    DropdownButton<FrequencyType>(
                      value: frequencyType,
                      onChanged: (FrequencyType? newValue) {
                        setState(() {
                          setDefaultData();
                          frequencyType = newValue!;
                        });
                      },
                      items: dropdownItems,
                    )
                  ],
                ),
              ),
              if (frequencyType == FrequencyType.DAILY)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Every: '),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                              controller: everyDailyNumber,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Text(
                            ' days',
                          )
                        ],
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
                              await _selectFromDate(context);
                            },
                            child: Text(DateFormat('dd-MM-yyyy')
                                .format(selectedFromDate)),
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          Text('End With: '),
                          DropdownButton<EndType>(
                            value: endType,
                            onChanged: (EndType? newValue) {
                              setState(() {
                                setDateTime(newValue!,int.parse(everyDailyNumber.text.replaceAll(',', '')));
                                endType = newValue!;         
                              });
                            },
                            items: dropdownItemsEnd,
                          )
                        ],
                      ),
                      if (endType == EndType.UNTIL)
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
                              child: Text(DateFormat('dd-MM-yyyy')
                                  .format(selectedToDate!)),
                            ))
                          ],
                        ),
                      if (endType == EndType.TIMES)
                        Row(
                          children: [
                            Text('Times: '),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                                controller: timeNumber,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        )
                    ],
                  )),
                ),
              if (frequencyType == FrequencyType.WEEKLY)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Every: '),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                              controller: everyDailyNumber,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Text(
                            ' weeks',
                          ),
                        ],
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
                              await _selectFromDate(context);
                            },
                            child: selectedFromDate != null ? Text(DateFormat('dd-MM-yyyy')
                                .format(selectedFromDate))
                                : Text('Select date') ,
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          Text('Select day: '),
                          DropdownButton<DayOfWeek>(
                            value: dayOfWeek,
                            onChanged: (DayOfWeek? newValue) {
                              setState(() {
                                dayOfWeek = newValue!;
                              });
                            },
                            items: dropdownItemsDayOfWeeks,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('End With: '),
                          DropdownButton<EndType>(
                            value: endType,
                            onChanged: (EndType? newValue) {
                              setState(() {
                                
                                setDateTime(newValue!,(int.parse(everyDailyNumber.text.replaceAll(',', '')) * 7) + 1);
                                endType = newValue!;
                                
                              });
                            },
                            items: dropdownItemsEnd,
                          )
                        ],
                      ),
                      if (endType == EndType.UNTIL)
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
                              child: Text(DateFormat('dd-MM-yyyy')
                                  .format(selectedToDate!)),
                            ))
                          ],
                        ),
                      if (endType == EndType.TIMES)
                        Row(
                          children: [
                            Text('Times: '),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                                controller: timeNumber,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        )
                    ],
                  )),
                ),
              if (frequencyType == FrequencyType.MONTHLY)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Every: '),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                              controller: everyDailyNumber,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Text(
                            ' months',
                          ),
                        ],
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
                              await _selectFromDate(context);
                            },
                            child: Text(DateFormat('dd-MM-yyyy')
                                .format(selectedFromDate)),
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          Text('Monthy Repeat Option: '),
                          DropdownButton<MonthOption>(
                            value: monthOption,
                            onChanged: (MonthOption? newValue) {
                              setState(() {
                                monthOption = newValue!;
                              });
                            },
                            items: dropdownItemsMonth,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('End With: '),
                          DropdownButton<EndType>(
                            value: endType,
                            onChanged: (EndType? newValue) {
                              setState(() {
                                setDateTime(newValue!,(31 * int.parse(everyDailyNumber.text.replaceAll(',', ''))) + 1);
                                endType = newValue!;
                              });
                            },
                            items: dropdownItemsEnd,
                          )
                        ],
                      ),
                      if (endType == EndType.UNTIL)
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
                              child: Text(DateFormat('dd-MM-yyyy')
                                  .format(selectedToDate!)),
                            ))
                          ],
                        ),
                      if (endType == EndType.TIMES)
                        Row(
                          children: [
                            Text('Times: '),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                                controller: timeNumber,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        )
                    ],
                  )),
                ),
              if (frequencyType == FrequencyType.YEARLY)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Every: '),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                              controller: everyDailyNumber,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Text(
                            ' years',
                          ),
                        ],
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
                              await _selectFromDate(context);
                            },
                            child: Text(DateFormat('dd-MM-yyyy')
                                .format(selectedFromDate)),
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          Text('End With: '),
                          DropdownButton<EndType>(
                            value: endType,
                            onChanged: (EndType? newValue) {
                              setState(() {
                                setDateTime(newValue!,(365 * int.parse(everyDailyNumber.text.replaceAll(',', '')))+1);
                                endType = newValue!;
                                
                              });
                            },
                            items: dropdownItemsEnd,
                          )
                        ],
                      ),
                      if (endType == EndType.UNTIL)
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
                              child: Text(DateFormat('dd-MM-yyyy')
                                  .format(selectedToDate!)),
                            ))
                          ],
                        ),
                      if (endType == EndType.TIMES)
                        Row(
                          children: [
                            Text('Times: '),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                                controller: timeNumber,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        )
                    ],
                  )),
                ),
              ElevatedButton(
                onPressed: () async {
                  //Validate
                  if (moneyNumber.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Alret'),
                          content: Text('Money is required!'),
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
                  if (categoryID == 0) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Alret'),
                          content: Text('Category is required!'),
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
                  if (everyDailyNumber.text.isEmpty || int.parse(everyDailyNumber.text.replaceAll(',', '')) <= 0 || int.parse(everyDailyNumber.text.replaceAll(',', '')) > 30) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Alret'),
                          content: Text('Every must greater than 0 and less than 30!'),
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
                  if (frequencyType == FrequencyType.DAILY ||
                      frequencyType == FrequencyType.MONTHLY ||
                      frequencyType == FrequencyType.WEEKLY ||
                      frequencyType == FrequencyType.YEARLY) {
                    if (endType == EndType.UNTIL &&
                        selectedToDate!.isBefore(selectedFromDate)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alret'),
                            content:
                                Text('To date must greater than from date'),
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
                    if (endType == EndType.TIMES && timeNumber.text.isEmpty || int.parse(timeNumber.text.replaceAll(',', '')) <= 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alret'),
                            content: Text('Times is required! and time times must greater than 0!'),
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
                  //
                  Recurrence recurrence = Recurrence(
                      frequency: "repeat ${frequencyType.name}",
                      every: int.parse(everyDailyNumber.text.replaceAll(',', '')),
                      startDate: selectedFromDate,
                      endType: endType,
                      endDate: selectedToDate,
                      times: timeNumber.text.isNotEmpty
                          ? int.parse(timeNumber.text.replaceAll(',', ''))
                          : 0,
                      monthOption: monthOption,
                      dayOfWeek: selectedDay!.toUpperCase(),
                      recurrenceId: 0,
                      userId: 0,
                      timesCompleted: 0,
                      dueDate: selectedFromDate);
                  TransactionRecurrence transRecu = TransactionRecurrence(
                      transactionRecurringId: 0,
                      userId: 0,
                      amount: double.parse(moneyNumber.text.replaceAll(',', '')),
                      recurrence: recurrence,
                      categoryId: categoryID,
                      walletId: walletID,
                      notes: '');
                  var result = await TransactionRecurrence_Service()
                      .InsertTransRe(transRecu);
                  if (result.status == 200) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Alret'),
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
                          title: Text('Alret'),
                          content: Text(result.message),
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
    );
  }

  void setDefaultData() {
    everyDailyNumber.text = "0";
    selectedToDate = null;
    frequencyType = FrequencyType.DAILY;
    endType = EndType.FOREVER;
    monthOption = MonthOption.SAMEDAY;
    dayOfWeek = DayOfWeek.MONDAY;
  }

  void setDateTime(EndType endType,int day) { 
    if (endType == EndType.UNTIL) {
      selectedToDate = DateTime.now().add(Duration(days: day));
    }
    if (endType == EndType.TIMES) {
      selectedToDate = null;
    }
  }
}
