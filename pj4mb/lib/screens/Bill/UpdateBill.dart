import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Bill/Bill.dart';
import 'package:pj4mb/models/Bill/DayOfWeeks.dart';
import 'package:pj4mb/models/Bill/EndType.dart';
import 'package:pj4mb/models/Bill/FrequencyType.dart';
import 'package:pj4mb/models/Bill/MonthOption.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/services/Bill_service.dart';
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class UpdateBillPage extends StatefulWidget {
  const UpdateBillPage({super.key, required this.bill});
  final Bill bill;

  @override
  State<UpdateBillPage> createState() => _UpdateBillPageState();
}

class _UpdateBillPageState extends State<UpdateBillPage> {
  //EditController
  TextEditingController moneyNumber = new TextEditingController();
  TextEditingController everyDailyNumber = new TextEditingController();
  TextEditingController timeNumber = new TextEditingController();
  //

  //Model
  Category? valueCate;
  late List<Category> valueCateResponse;
  late Future<List<Wallet>> valueWallet;
  late Wallet? wallet;
  //

  //variable
  late int walletID = 0;
  late String walletName = '';
  int categoryID = 0;
  String categoryName = '';
  DateTime selectedFromDate = DateTime.now();
  DateTime? selectedToDate;
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
  late FrequencyType frequencyType = FrequencyType.DAILY;
  late EndType endType = EndType.FOREVER;
  late MonthOption monthOption = MonthOption.SAMEDAY;
  late DayOfWeek dayOfWeek = DayOfWeek.MONDAY;
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
    loadDefaultData();
    moneyNumber.text = widget.bill.amount.toString();
    categoryID = widget.bill.categoryId;
    everyDailyNumber.text = widget.bill.recurrence.every.toString();
    frequencyType = FrequencyType.values.firstWhere((e) =>
        e.toString() == 'FrequencyType.${widget.bill.recurrence.frequency}');
    endType = EndType.values.firstWhere((e) =>
        e.toString() == 'EndType.${widget.bill.recurrence.endType.name}');
    monthOption = MonthOption.values.firstWhere((e) =>
        e.toString() ==
        'MonthOption.${widget.bill.recurrence.monthOption.name}');
    dayOfWeek = DayOfWeek.values.firstWhere(
        (e) => e.toString() == 'DayOfWeek.${widget.bill.recurrence.dayOfWeek}');
    timeNumber.text = widget.bill.recurrence.times.toString();
    selectedToDate = widget.bill.recurrence.endDate;
    selectedFromDate = widget.bill.recurrence.startDate;
  }

  void loadDefaultData() async {
    valueCateResponse = await CategoryService().GetCategory();
    valueCate = valueCateResponse
        .firstWhere((element) => element.categoryID == widget.bill.categoryId);
    setState(() {
      categoryID = valueCate!.categoryID;
      categoryName = valueCate!.name;
    });
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
          "Update bill",
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm?'),
                    content: Text('Are you sure to delete this bill ?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          var result = await BillService()
                              .DeleteBill(widget.bill.billId);
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
                                  content: Text(
                                      'Delete fail! ${result.message.toString()}'),
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
            }
          )
        ],
      ),
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
                          wallet = snapshot.data!.firstWhere((element) =>
                              element.walletID == widget.bill.walletId);
                          walletID = wallet!.walletID;
                          walletName = wallet!.walletName;
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
                                setDateTime(newValue!);
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
                                setDateTime(newValue!);
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
                                selectedToDate!.add(Duration(days: 1));
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
                                setDateTime(newValue!);
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
                  Recurrence recurrence = Recurrence(
                      frequency: "repeat ${frequencyType.name}",
                      every: int.parse(everyDailyNumber.text),
                      startDate: selectedFromDate,
                      endType: endType,
                      endDate: selectedToDate,
                      times: timeNumber.text.isNotEmpty
                          ? int.parse(timeNumber.text)
                          : 0,
                      monthOption: monthOption,
                      dayOfWeek: selectedDay!.toUpperCase(),
                      recurrenceId: widget.bill.recurrence.recurrenceId,
                      userId: 0,
                      timesCompleted: widget.bill.recurrence.timesCompleted,
                      dueDate: selectedFromDate);
                  Bill bill = new Bill(
                      billId: widget.bill.billId,
                      userId: 0,
                      amount: double.parse(moneyNumber.text),
                      recurrence: recurrence,
                      categoryId: categoryID,
                      walletId: walletID);
                  var result = await BillService().UpdateBill(bill);
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
                child: Text('Update'),
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

  void setDateTime(EndType endType) {
    if (endType == EndType.UNTIL) {
      selectedToDate = DateTime.now().add(Duration(days: 1));
    }
    if (endType == EndType.TIMES) {
      selectedToDate = null;
    }
  }
}
