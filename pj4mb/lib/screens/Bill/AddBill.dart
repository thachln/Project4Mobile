import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Bill/EndType.dart';
import 'package:pj4mb/models/Bill/FrequencyType.dart';
import 'package:pj4mb/models/Bill/MonthOption.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class AddBillPage extends StatefulWidget {
  const AddBillPage({super.key});

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  //EditController
  TextEditingController moneyNumber = new TextEditingController();
  TextEditingController noteText = new TextEditingController();
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
  DateTime selectedToDate = DateTime.now();
  final List<String> days = [
    'Monday',
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
    valueWallet = WalletService().GetWallet();
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
    return Scaffold(
      //backgroundColor: Colors.black87,
      appBar: AppBar(
          title: Text(
        "Add new bill",
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
                      keyboardType: TextInputType.number,
                    ),
                  )
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
                      valueCate = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                    flag: 1,
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
                height: 20,
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
                  ),
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
                                  .format(selectedToDate)),
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
                            child: Text(DateFormat('dd-MM-yyyy')
                                .format(selectedFromDate)),
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          Text('Select day: '),
                          DropdownButton<String>(
                            value: selectedDay,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDay = newValue;
                              });
                            },
                            items: days
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('End With: '),
                          DropdownButton<EndType>(
                            value: endType,
                            onChanged: (EndType? newValue) {
                              setState(() {
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
                                  .format(selectedToDate)),
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
                                  .format(selectedToDate)),
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
                                  .format(selectedToDate)),
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
                onPressed: () async {},
                child: Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
