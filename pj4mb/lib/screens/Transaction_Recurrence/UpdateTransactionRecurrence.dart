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
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/services/TransactionRecurrence_service.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class UpdateTransactionRecurrencePage extends StatefulWidget {
  const UpdateTransactionRecurrencePage({super.key, required this.transactionRecurrence});
  final TransactionRecurrence transactionRecurrence;

  @override
  State<UpdateTransactionRecurrencePage> createState() => _UpdateTransactionRecurrencePageState();
}

class _UpdateTransactionRecurrencePageState extends State<UpdateTransactionRecurrencePage> {
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
    moneyNumber.text =  NumberFormat('#,##0','en_US').format(widget.transactionRecurrence.amount);
    categoryID = widget.transactionRecurrence.categoryId;
    everyDailyNumber.text = NumberFormat('#,##0','en_US').format(widget.transactionRecurrence.recurrence.every);
    if(widget.transactionRecurrence.recurrence.frequency != null){
      frequencyType = FrequencyType.values.firstWhere((e) =>
        e.toString() == 'FrequencyType.${widget.transactionRecurrence.recurrence.frequency}');
    }
    if(widget.transactionRecurrence.recurrence.endType != null){
       endType = EndType.values.firstWhere((e) =>
        e.toString() == 'EndType.${widget.transactionRecurrence.recurrence.endType.name}');
    }
   if(widget.transactionRecurrence.recurrence.monthOption != null){
        monthOption = MonthOption.values.firstWhere((e) =>
        e.toString() ==
        'MonthOption.${widget.transactionRecurrence.recurrence.monthOption!.name}');
    }
   
   if(widget.transactionRecurrence.recurrence.dayOfWeek != null){
    dayOfWeek = DayOfWeek.values.firstWhere(
        (e) => e.toString() == 'DayOfWeek.${widget.transactionRecurrence.recurrence.dayOfWeek}');
   }
   
    
    timeNumber.text = NumberFormat('#,##0','en_US').format(widget.transactionRecurrence.recurrence.times);
    selectedToDate = widget.transactionRecurrence.recurrence.endDate;
    selectedFromDate = widget.transactionRecurrence.recurrence.startDate;
  }

  void loadDefaultData() async {
    valueCateResponse = await CategoryService().GetCategory();
    valueCate = valueCateResponse
        .firstWhere((element) => element.categoryID == widget.transactionRecurrence.categoryId);
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
          "Update Transaction Recurrence",
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
                    content: Text('Are you sure to delete this transaction recurrence ?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          var result = await TransactionRecurrence_Service()
                              .DeleteTransRe(widget.transactionRecurrence.transactionRecurringId);
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                                element.walletID == widget.transactionRecurrence.walletId);
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
                                  categoryID = 0;
                                  categoryName = '';
                                });
            
                              },
                              items: snapshot.data!.where((element) => element.walletTypeID != 3).map((Wallet value) {
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
                          ? Text('Choose category')
                          : Text(categoryName),
                    ))
                  ],
                ),
                
                
                Row(
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
                
                if (frequencyType == FrequencyType.DAILY)
                  Container(
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
                  
                if (frequencyType == FrequencyType.WEEKLY)
                  Container(
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
                                print(newValue);
                                setState(() {
                                  setDateTime(newValue!,int.parse(everyDailyNumber.text.replaceAll(',', '')) * 7);
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
                 
                if (frequencyType == FrequencyType.MONTHLY)
                  Container(
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
                                  setDateTime(newValue!,31 * int.parse(everyDailyNumber.text.replaceAll(',', '')) + 1);
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
                
                if (frequencyType == FrequencyType.YEARLY)
                  Container(
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
                                  setDateTime(newValue!,365 * int.parse(everyDailyNumber.text.replaceAll(',', '')));
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
                 
                ElevatedButton(
                  onPressed: () async {
                    if(moneyNumber.text.isEmpty){
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
                    if(categoryID == 0){
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
                    if(walletID == 0){
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
                    if(selectedFromDate.isBefore(DateTime.now().subtract(Duration(days: 1)))){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alret'),
                            content: Text('From date must be greater than today!'),
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
                    if(frequencyType == FrequencyType.DAILY || frequencyType == FrequencyType.MONTHLY || frequencyType == FrequencyType.WEEKLY || frequencyType == FrequencyType.YEARLY)
                    {
                      if(endType == EndType.UNTIL && selectedToDate!.isBefore(selectedFromDate)){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alret'),
                              content: Text('To date must greater than from date'),
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
                      if(endType == EndType.TIMES && (timeNumber.text.isEmpty || int.parse(timeNumber.text.replaceAll(',', '')) <= 0)){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alret'),
                              content: Text('Times is required and time must greater than 0!'),
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
                        recurrenceId: widget.transactionRecurrence.recurrence.recurrenceId,
                        userId: 0,
                        timesCompleted: widget.transactionRecurrence.recurrence.timesCompleted,
                        dueDate: selectedFromDate);
                    TransactionRecurrence transRecu = TransactionRecurrence(
                        transactionRecurringId: widget.transactionRecurrence.transactionRecurringId,
                        userId: 0,
                        amount: double.parse(moneyNumber.text.replaceAll(',', '')),
                        recurrence: recurrence,
                        categoryId: categoryID,
                        walletId: walletID, notes: '');
                    var result = await TransactionRecurrence_Service().UpdateTransRe(transRecu);
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
    else {
      selectedToDate = null;
    }
  }
}
