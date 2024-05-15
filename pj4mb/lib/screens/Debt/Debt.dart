import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Budget/ListDateTime.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Debt/Debt.dart';
import 'package:pj4mb/screens/Debt/AddDebt.dart';
import 'package:pj4mb/screens/Debt/ReportDebt.dart';
import 'package:pj4mb/services/Debt_service.dart';
import 'package:pj4mb/widgets/Account/ListDebt.dart';

class DebtPage extends StatefulWidget {
  const DebtPage({super.key});

  @override
  State<DebtPage> createState() => _DebtPageState();
}

class _DebtPageState extends State<DebtPage> with TickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<Debt>> debt;
  late Future<List<Debt>> loan;
  late DateTime fromDate;
  late DateTime toDate;
  late DateTime fromDateLoan;
  late DateTime toDateLoan;
  late ListDateTime listDateTime;
  late ParamPudget param;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    
    listDateTime = getFullDays(DateTime.now());
    fromDate = listDateTime.startOfMonth;
    toDate = listDateTime.endOfMonth;
    fromDateLoan = listDateTime.startOfMonth;
    toDateLoan = listDateTime.endOfMonth;
    param = ParamPudget(userId: 0, fromDate: fromDate, toDate: toDate);
    debt = DebthService().findDebt(param);
    loan = DebthService().findLoan(param);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _selectFromDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != fromDate) {
        setState(() {
          fromDate = picked;
        });
      }
    }

    Future<void> _selectToDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != toDate) {
        setState(() {
          toDate = picked;
        });
      }
    }

    Future<void> _selectFromDateLoan(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDateLoan,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != fromDateLoan) {
        setState(() {
          fromDateLoan = picked;
        });
      }
    }

    Future<void> _selectToDateLoan(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toDateLoan,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != toDateLoan) {
        setState(() {
          toDateLoan = picked;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Debt'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReportDebt()));
              },
              child: Text('View report'))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            controller: _tabController,
            onTap: (index) {},
            tabs: [
              Tab(text: 'Debt'),
              Tab(text: 'Loan'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FutureBuilder<List<Debt>>(
                  future: debt,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Debt>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: 130,
                                    height: 50,
                                    child: Row(children: [
                                      Text('From: '),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () async {
                                          await _selectFromDate(context);
                                        },
                                        child: Text(DateFormat('dd-MM-yyyy')
                                            .format(fromDate)),
                                      ))
                                    ])),
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: 130,
                                    height: 50,
                                    child: Row(children: [
                                      Text('To: '),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () async {
                                          await _selectToDate(context);
                                          if (toDate.isBefore(fromDate)) {
                                            toDate = fromDate;
                                          }
                                        },
                                        child: Text(DateFormat('dd-MM-yyyy')
                                            .format(toDate)),
                                      ))
                                    ])),
                                TextButton(
                                    onPressed: () async {
                                      ParamPudget param = ParamPudget(userId: 0, fromDate: fromDate, toDate: toDate);
                                      var result =  DebthService().findDebt(param);
                                      setState(() {
                                        debt = result;
                                      });
                                    },
                                    child: Text('Search'))
                              ],
                            ),
                          ),
                          Container(
                            child: ListDebt(
                              onSave: (value) {
                                setState(() {
                                  debt = DebthService().findDebt(param);
                                  loan = DebthService().findLoan(param);
                                });
                              },
                              listDebt: snapshot.data!,
                              flag: 0,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                FutureBuilder<List<Debt>>(
                  future: loan,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Debt>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: 130,
                                    height: 50,
                                    child: Row(children: [
                                      Text('From: '),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () async {
                                          await _selectFromDateLoan(context);
                                        },
                                        child: Text(DateFormat('dd-MM-yyyy')
                                            .format(fromDateLoan)),
                                      ))
                                    ])),
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: 130,
                                    height: 50,
                                    child: Row(children: [
                                      Text('To: '),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () async {
                                          await _selectToDateLoan(context);
                                        },
                                        child: Text(DateFormat('dd-MM-yyyy')
                                            .format(toDateLoan)),
                                      ))
                                    ])),
                                TextButton(
                                    onPressed: () async {
                                      ParamPudget param = ParamPudget(userId: 0, fromDate: fromDateLoan, toDate: toDateLoan);
                                      var result =  DebthService().findLoan(param);
                                      setState(() {
                                        loan = result;
                                      });
                                    },
                                    child: Text('Search'))
                              ],
                            ),
                          ),
                          Container(
                            child: ListDebt(
                              onSave: (value) {
                                setState(() {
                                  debt = DebthService().findDebt(param);
                                  loan = DebthService().findLoan(param);
                                });
                              },
                              listDebt: snapshot.data!,
                              flag: 1,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          mini: true,
          child: Icon(Icons.add),
          onPressed: () async {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddDebtPage()));
            if (result) {
              setState(() {
                debt = DebthService().findDebt(param);
                loan = DebthService().findLoan(param);
              });
            }
          },
          backgroundColor: Colors.pink[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );
  }

  ListDateTime getFullDays(DateTime dateTime) {
    //Month
    DateTime startOfMonth = DateTime(dateTime.year, dateTime.month, 1);
    DateTime endOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);

    ListDateTime listDateTime = ListDateTime(
        startOfWeek: DateTime.now(),
        endOfWeek: DateTime.now(),
        startOfMonth: startOfMonth,
        endOfMonth: endOfMonth,
        firstDayOfQuarter: DateTime.now(),
        lastDayOfQuarter: DateTime.now(),
        startOfYear: DateTime.now(),
        endOfYear: DateTime.now());
    return listDateTime;
  }
}
