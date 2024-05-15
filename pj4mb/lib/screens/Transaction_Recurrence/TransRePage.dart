import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Bill/Bill.dart';
import 'package:pj4mb/models/Bill/BillResponse.dart';
import 'package:pj4mb/models/Budget/ListDateTime.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/TransactionRecurrence/TransRecuResponce.dart';
import 'package:pj4mb/screens/Bill/AddBill.dart';
import 'package:pj4mb/screens/Transaction_Recurrence/AddTranRecu.dart';
import 'package:pj4mb/services/Bill_service.dart';
import 'package:pj4mb/services/TransactionRecurrence_service.dart';
import 'package:pj4mb/widgets/Bill/BillList.dart';
import 'package:pj4mb/widgets/TransactionRecurrence/TranRecuList.dart';

class TransRePage extends StatefulWidget {
  const TransRePage({super.key});

  @override
  State<TransRePage> createState() => _TransRePageState();
}

class _TransRePageState extends State<TransRePage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<TransRecuResponce>> transRecuActive;
  late Future<List<TransRecuResponce>> transRecuExpired;
    late DateTime fromDate;
  late DateTime toDate;
  late DateTime fromDateExpired;
  late DateTime toDateExpired;
  late ListDateTime listDateTime;
  late ParamPudget param;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
     listDateTime = getFullDays(DateTime.now());
    fromDate = listDateTime.startOfMonth;
    toDate = listDateTime.endOfMonth;
    fromDateExpired = listDateTime.startOfMonth;
    toDateExpired = listDateTime.endOfMonth;
    param = ParamPudget(userId: 0, fromDate: fromDate, toDate: toDate);
    transRecuActive = TransactionRecurrence_Service().findRecuActive(param);
    transRecuExpired = TransactionRecurrence_Service().findRecuExpired(param);
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

    Future<void> _selectFromDateExpired(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDateExpired,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != fromDateExpired) {
        setState(() {
          fromDateExpired = picked;
        });
      }
    }

    Future<void> _selectToDateExpired(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toDateExpired,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != toDateExpired) {
        setState(() {
          toDateExpired = picked;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Recurrence'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              controller: _tabController,
              // Đặt index của tab hiện tại
              onTap: (index) {},
              tabs: [
                Tab(text: 'Working'),
                Tab(text: 'Finished'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
                                  param = ParamPudget(
                                      userId: 0,
                                      fromDate: fromDate,
                                      toDate: toDate);
                                
                                  var result = TransactionRecurrence_Service().findRecuActive(param);
   
                                  setState(() {
                                    transRecuActive = result;
                                  });
                                },
                                child: Text('Search'))
                          ],
                        ),
                      ),
                      FutureBuilder<List<TransRecuResponce>>(
                        future: transRecuActive,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TransRecuResponce>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            if (snapshot.data!.isEmpty) {
                              return Center(child: Text('No data'));
                            }
                            return TranRecuList(
                              listTranRecu: snapshot.data!,
                              onSave: (value) {
                                setState(() {
                                 transRecuActive = TransactionRecurrence_Service().findRecuActive(param);
                                  transRecuExpired = TransactionRecurrence_Service().findRecuExpired(param);
                                });
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Column(
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
                                      await _selectFromDateExpired(context);
                                    },
                                    child: Text(DateFormat('dd-MM-yyyy')
                                        .format(fromDateExpired)),
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
                                      await _selectToDateExpired(context);
                                      if (toDateExpired.isBefore(fromDateExpired)) {
                                        toDateExpired = fromDateExpired;
                                      }
                                    },
                                    child: Text(DateFormat('dd-MM-yyyy')
                                        .format(toDateExpired)),
                                  ))
                                ])),
                            TextButton(
                                onPressed: () async {
                                  param = ParamPudget(
                                      userId: 0,
                                      fromDate: fromDateExpired,
                                      toDate: toDateExpired);

                                   var result = TransactionRecurrence_Service().findRecuExpired(param);
   
                                  setState(() {
                                    transRecuActive = result;
                                  });
                                },
                                child: Text('Search'))
                          ],
                        ),
                      ),
                      FutureBuilder<List<TransRecuResponce>>(
                        future: transRecuExpired,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TransRecuResponce>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            if (snapshot.data!.isEmpty) {
                              return Center(child: Text('No data'));
                            }
                            return TranRecuList(
                              listTranRecu: snapshot.data!,
                              onSave: (value) {
                                setState(() {
                                  transRecuActive = TransactionRecurrence_Service().findRecuActive(param);
                          transRecuExpired = TransactionRecurrence_Service().findRecuExpired(param);
                                });
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ]
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTranRecuPage()));
            if (result) {
              setState(() {
                transRecuActive = TransactionRecurrence_Service().findRecuActive(param);
    transRecuExpired = TransactionRecurrence_Service().findRecuExpired(param);
              });
            }
          },
          backgroundColor: Colors.pink[200],
          mini: true,
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
