import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Budget/Budget.dart';
import 'package:pj4mb/models/Budget/ListDateTime.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Account/MyWallet.dart';
import 'package:pj4mb/screens/ThousandsSeparatorInputFormatter.dart';
import 'package:pj4mb/services/Budget_service.dart';

import '../Account/Category.dart';

class AddBudgetPage extends StatefulWidget {
  @override
  _AddBudgetPageState createState() => _AddBudgetPageState();
}

enum TimeSelection { week, month, quarter, year, custom }

class _AddBudgetPageState extends State<AddBudgetPage> {
  TimeSelection _timeSelection = TimeSelection.week;
  String dropdownValue = 'VND';
  late ListDateTime listDateTime;

  late DateTime selectedDateStart;
  late DateTime selectedDateEnd;
  late TextEditingController amountController;
  String categoryName = '';
  int categoryId = 0;
  String walletName = '';

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    listDateTime = getFullDays(DateTime.now());
    selectedDateStart = listDateTime.startOfWeek;
    selectedDateEnd = listDateTime.endOfWeek;
  }

  @override
  Widget build(BuildContext context) {
    Category? valueCate;
    Wallet? valueWallet;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
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
                                Type: "Ex",
                              )),
                    );

                    setState(() {
                      if (valueCate != null) {
                        // Update here using the selected category name
                        categoryName = valueCate!.name;
                        categoryId = valueCate!.categoryID;
                      }
                    });
                  },
                  child: categoryName.trim().isEmpty
                      ? Text('Chosse Category')
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
                    controller: amountController,
                     inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Amount'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(Icons.date_range),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: InkWell(
                  onTap: _showTimeSelectionDialog,
                  child: DateFormat('dd-MM-yyyy').format(selectedDateStart) ==
                          '01-01-2000'
                      ? Text('Choose date')
                      : Text(
                          '${DateFormat('dd-MM-yyyy').format(selectedDateStart)} - ${DateFormat('dd-MM-yyyy').format(selectedDateEnd)}'),
                ))
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                if (categoryId == 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
                        content: Text('Please choose category!'),
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
                if (amountController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
                        content: Text('Please enter amount!'),
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
                if(double.parse(amountController.text.replaceAll(',', '')) <= 0){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
                        content: Text('Amount must be greater than 0!'),
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
                Budget budget = new Budget(
                  threshold_amount: double.parse(amountController.text.replaceAll(',', '')),
                  categoryId: categoryId,
                  userId: 0,
                  period_start: selectedDateStart,
                  period_end: selectedDateEnd,
                  budgetId: 0,
                  amount: 0,
                );
                var result = await Budget_Service().InsertBudget(budget);
                if (result.status == 200) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
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
                        title: Text('Arlet'),
                        content: Text('Error: Insert fail! ${result.message}'),
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
    );
  }

  Future<void> _showTimeSelectionDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context1) {
        TimeSelection localSelection = _timeSelection;
        DateTime localCustomStartDate = selectedDateStart;
        DateTime localCustomEndDate = selectedDateEnd;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AlertDialog(
              alignment: Alignment.topLeft,
              title: Text('Chọn khoảng thời gian'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RadioListTile<TimeSelection>(
                      title: Text(
                          'Tuần này (${DateFormat('dd-MM').format(listDateTime.startOfWeek)} - ${DateFormat('dd-MM').format(listDateTime.endOfWeek)})'),
                      value: TimeSelection.week,
                      groupValue: localSelection,
                      onChanged: (TimeSelection? value) {
                        setModalState(() {
                          localSelection = value!;
                        });
                        setState(() {
                          selectedDateStart = listDateTime.startOfWeek;
                          selectedDateEnd = listDateTime.endOfWeek;
                        });
                      },
                    ),
                    RadioListTile<TimeSelection>(
                      title: Text(
                          'Tháng này (${DateFormat('dd-MM').format(listDateTime.startOfMonth)} - ${DateFormat('dd-MM').format(listDateTime.endOfMonth)})'),
                      value: TimeSelection.month,
                      groupValue: localSelection,
                      onChanged: (TimeSelection? value) {
                        setModalState(() {
                          localSelection = value!;
                        });
                        setState(() {
                          selectedDateStart = listDateTime.startOfMonth;
                          selectedDateEnd = listDateTime.endOfMonth;
                        });
                      },
                    ),
                    RadioListTile<TimeSelection>(
                      title: Text(
                          'Quý này (${DateFormat('dd-MM').format(listDateTime.firstDayOfQuarter)} - ${DateFormat('dd-MM').format(listDateTime.lastDayOfQuarter)})'),
                      value: TimeSelection.quarter,
                      groupValue: localSelection,
                      onChanged: (TimeSelection? value) {
                        setModalState(() {
                          localSelection = value!;
                        });
                        setState(() {
                          selectedDateStart = listDateTime.firstDayOfQuarter;
                          selectedDateEnd = listDateTime.lastDayOfQuarter;
                        });
                      },
                    ),
                    RadioListTile<TimeSelection>(
                      title: Text(
                          'Năm này (${DateFormat('dd-MM-yyyy').format(listDateTime.startOfYear)} - ${DateFormat('dd-MM-yyyy').format(listDateTime.endOfYear)})'),
                      value: TimeSelection.year,
                      groupValue: localSelection,
                      onChanged: (TimeSelection? value) {
                        setModalState(() {
                          localSelection = value!;
                        });
                        setState(() {
                          selectedDateStart = listDateTime.startOfYear;
                          selectedDateEnd = listDateTime.endOfYear;
                        });
                      },
                    ),
                    RadioListTile<TimeSelection>(
                      title: Text('Tùy chọn'),
                      value: TimeSelection.custom,
                      groupValue: localSelection,
                      onChanged: (TimeSelection? value) {
                        setModalState(() {
                          localSelection = value!;
                        });
                      },
                    ),
                    if (localSelection == TimeSelection.custom) ...[
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? startDate = await showDatePicker(
                            context: context,
                            initialDate: localCustomStartDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (startDate != null) {
                            setModalState(() {
                              localCustomStartDate = startDate;
                            });
                            setState(() {
                              selectedDateStart = startDate;
                            });
                          }
                        },
                        child: Text(
                            'Choose Start Date: ${localCustomStartDate.toString().split(' ')[0]}'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? endDate = await showDatePicker(
                            context: context,
                            initialDate: localCustomEndDate,
                            firstDate:
                                localCustomStartDate, // Ngày kết thúc không thể trước ngày bắt đầu
                            lastDate: DateTime(2100),
                          );
                          if (endDate != null) {
                            setModalState(() {
                              localCustomEndDate = endDate;
                            });
                            setState(() {
                              selectedDateEnd = endDate;
                            });
                          }
                        },
                        child: Text(
                            'Choose End Date: ${localCustomEndDate.toString().split(' ')[0]}'),
                      ),
                    ],
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancle'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Confirm?'),
                  onPressed: () {
                    if (DateFormat('dd-MM-yyyy').format(selectedDateStart) ==
                            '01-01-2000' &&
                        DateFormat('dd-MM-yyyy').format(selectedDateEnd) ==
                            '01-01-2000') {               
                      setState(() {
                        selectedDateStart = listDateTime.startOfWeek;
                        selectedDateEnd = listDateTime.endOfWeek;
                      });
                    }                   
                      if (selectedDateEnd.isBefore(
                          selectedDateStart.subtract(Duration(days: 1)))) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Arlet'),
                              content: Text(
                                  'Please choose end date after date start!'),
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
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  ListDateTime getFullDays(DateTime dateTime) {
    //Weeks
    DateTime startOfWeek =
        dateTime.subtract(Duration(days: dateTime.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    //

    //Month
    DateTime startOfMonth = DateTime(dateTime.year, dateTime.month, 1);
    DateTime endOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);

    //Ceil
    int quarter = (dateTime.month / 3).ceil();

    // Tính toán ngày đầu và ngày cuối của quý
    DateTime firstDayOfQuarter =
        DateTime(dateTime.year, (quarter - 1) * 3 + 1, 1);
    DateTime lastDayOfQuarter = DateTime(dateTime.year, quarter * 3 + 1, 0);

    //Year
    DateTime startOfYear = DateTime(dateTime.year, 1, 1);
    DateTime endOfYear = DateTime(dateTime.year, 12, 31);

    ListDateTime listDateTime = ListDateTime(
        startOfWeek: startOfWeek,
        endOfWeek: endOfWeek,
        startOfMonth: startOfMonth,
        endOfMonth: endOfMonth,
        firstDayOfQuarter: firstDayOfQuarter,
        lastDayOfQuarter: lastDayOfQuarter,
        startOfYear: startOfYear,
        endOfYear: endOfYear);
    return listDateTime;
  }
}
