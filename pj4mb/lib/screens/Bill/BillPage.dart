import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Bill/Bill.dart';
import 'package:pj4mb/models/Bill/BillResponse.dart';
import 'package:pj4mb/models/Budget/ListDateTime.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/screens/Bill/AddBill.dart';
import 'package:pj4mb/services/Bill_service.dart';
import 'package:pj4mb/widgets/Bill/BillList.dart';

class BillPage extends StatefulWidget {
  const BillPage({super.key});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> with TickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<BillResponse>> billActive;
  late Future<List<BillResponse>> billExpired;
  late DateTime fromDate;
  late DateTime toDate;
  late DateTime fromDateFinished;
  late DateTime toDateFinished;
  late ListDateTime listDateTime;
  late ParamPudget param;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    listDateTime = getFullDays(DateTime.now());
    fromDate = listDateTime.startOfMonth;
    toDate = listDateTime.endOfMonth;
    fromDateFinished = listDateTime.startOfMonth;
    toDateFinished = listDateTime.endOfMonth;
    param = ParamPudget(userId: 0, fromDate: fromDate, toDate: toDate);
    billActive = BillService().findBillActive(param);
    billExpired = BillService().findBillExpired(param);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

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

  Future<void> _selectFromDateFinished(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDateFinished,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fromDateFinished) {
      setState(() {
        fromDateFinished = picked;
      });
    }
  }

  Future<void> _selectToDateFinished(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDateFinished,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != toDateFinished) {
      setState(() {
        toDateFinished = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill'),
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
                                  var result =
                                      BillService().findBillActive(param);
                                  setState(() {
                                    billActive = result;
                                  });
                                },
                                child: Text('Search'))
                          ],
                        ),
                      ),
                      FutureBuilder<List<BillResponse>>(
                        future: billActive,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<BillResponse>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            if (snapshot.data!.isEmpty) {
                              return Center(child: Text('No data'));
                            }
                            return BillList(
                              listBill: snapshot.data!,
                              onSave: (value) {
                                param = ParamPudget(
                                    userId: 0,
                                    fromDate: fromDate,
                                    toDate: toDate);
                                var result =
                                    BillService().findBillActive(param);
                                setState(() {
                                  billActive = result;
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
                                      await _selectFromDateFinished(context);
                                    },
                                    child: Text(DateFormat('dd-MM-yyyy')
                                        .format(fromDateFinished)),
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
                                      await _selectToDateFinished(context);
                                      if (toDateFinished
                                          .isBefore(fromDateFinished)) {
                                        toDateFinished = fromDateFinished;
                                      }
                                    },
                                    child: Text(DateFormat('dd-MM-yyyy')
                                        .format(toDateFinished)),
                                  ))
                                ])),
                            TextButton(
                                onPressed: () async {
                                  param = ParamPudget(
                                      userId: 0,
                                      fromDate: fromDateFinished,
                                      toDate: toDateFinished);

                                  var result =
                                      BillService().findBillExpired(param);
                                  setState(() {
                                    billExpired = result;
                                  });
                                },
                                child: Text('Search'))
                          ],
                        ),
                      ),
                      FutureBuilder<List<BillResponse>>(
                        future: billExpired,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<BillResponse>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            if (snapshot.data!.isEmpty) {
                              return Center(child: Text('No data'));
                            }
                            return BillList(
                              listBill: snapshot.data!,
                              onSave: (value) {
                                param = ParamPudget(
                                    userId: 0,
                                    fromDate: fromDate,
                                    toDate: toDate);
                                var active =
                                    BillService().findBillActive(param);
                                var expired =
                                    BillService().findBillExpired(param);
                                setState(() {
                                  billActive = active;
                                  billExpired = expired;
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddBillPage()));
            if (result) {
              param =
                  ParamPudget(userId: 0, fromDate: fromDate, toDate: toDate);
              var active = BillService().findBillActive(param);
              var expired = BillService().findBillExpired(param);
              setState(() {
                billActive = active;
                billExpired = expired;
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
