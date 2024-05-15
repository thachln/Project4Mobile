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

class UpdateBudgetPage extends StatefulWidget {
  const UpdateBudgetPage({Key? key, required this.budget, required this.cate})
      : super(key: key);
  final Budget budget;
  final CategoryResponse cate;
  
  @override
  _UpdateBudgetPageState createState() => _UpdateBudgetPageState();
}

enum TimeSelection { week, month, quarter, year, custom }

class _UpdateBudgetPageState extends State<UpdateBudgetPage> {
  TimeSelection _timeSelection = TimeSelection.week;
  String dropdownValue = 'VND';
  late ListDateTime listDateTime;

  late DateTime selectedDateStart = new DateTime(1, 1, 1);
  late DateTime selectedDateEnd = new DateTime(1, 1, 1);
  late TextEditingController amountController = new TextEditingController();
  String categoryName = '';
  int categoryId = 0;
  String walletName = '';
  Category? valueCate;
  @override
  void initState() {
    super.initState();
    amountController.text = NumberFormat('#,##0','en_US').format(widget.budget.threshold_amount);
    selectedDateStart = widget.budget.period_start;
    selectedDateEnd = widget.budget.period_end;
    categoryId = widget.budget.categoryId;
    categoryName = widget.cate.name;
    listDateTime = getFullDays(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Budget'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm?'),
                    content: Text('Are you sure to delete this budget ?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          var result = await Budget_Service()
                              .DeleteBudget(widget.budget.budgetId);
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
            },
            icon: Icon(Icons.delete),
          ),
        ],
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
                                Type:"Ex",
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
                     inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                    controller: amountController,
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
                          '01-01-0001'
                      ? Text('Choose date')
                      : Text(
                          '${DateFormat('dd-MM-yyyy').format(selectedDateStart)} - ${DateFormat('dd-MM-yyyy').format(selectedDateEnd)}'),
                ))
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                if(categoryId == 0){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Alert'),
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
                if(amountController.text.isEmpty){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Alert'),
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
                        title: Text('Alert'),
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
                  budgetId: widget.budget.budgetId,
                  amount: widget.budget.amount,
                );
                var result = await Budget_Service().UpdateBudget(budget);
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
                        content: Text('${result.message.toString()}'),
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
                            'Chọn ngày bắt đầu: ${localCustomStartDate.toString().split(' ')[0]}'),
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
                            'Chọn ngày kết thúc: ${localCustomEndDate.toString().split(' ')[0]}'),
                      ),
                    ],
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Hủy'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Xác nhận'),
                  onPressed: () {
                    if (DateFormat('dd-MM-yyyy').format(selectedDateStart) ==
                            '01-01-0001' &&
                        DateFormat('dd-MM-yyyy').format(selectedDateEnd) ==
                            '01-01-0001') {
                      setState(() {
                        selectedDateStart = listDateTime.startOfWeek;
                        selectedDateEnd = listDateTime.endOfWeek;
                      });
                    }
                    // setState(() {
                    //   _timeSelection = localSelection;
                    //   selectedDateStart = localCustomStartDate;
                    //   selectedDateEnd = localCustomEndDate;
                    // });
                    Navigator.of(context).pop();
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
