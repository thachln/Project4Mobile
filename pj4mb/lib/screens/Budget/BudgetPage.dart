import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/models/Budget/Budget.dart';
import 'package:pj4mb/models/Budget/ListDateTime.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/screens/Budget/AddBudgetPage.dart';
import 'package:pj4mb/services/Budget_service.dart';
import 'package:pj4mb/widgets/Budget/BudgetList.dart';

import 'package:pj4mb/widgets/Overview/ListOverview.dart';
import '../../aset/custom_arc_180_painter.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<BudgetResponse>> listBudget;
  late Future<List<BudgetResponse>> listBudgetPast;
  late Future<List<BudgetResponse>> listBudgetFuture;
  late ListDateTime listDateTime;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this,initialIndex: 1);
    listDateTime = getFullDays(DateTime.now());
    var param = ParamPudget(
        userId: 0,
        fromDate: listDateTime.startOfMonth,
        toDate: listDateTime.endOfMonth);
    listBudget = Budget_Service().GetBudgetWithTime(param);
    listBudgetPast = Budget_Service().GetBudgetPast(param);
    var param2 = ParamPudget(
        userId: 0,
        fromDate: listDateTime.endOfMonth,
        toDate: listDateTime.endOfMonth);
    listBudgetFuture = Budget_Service().GetBudgetFuture(param2);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Budget'),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [           
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Past',),
                  Tab(text: 'This Month'),
                  Tab(text: 'Future',)
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    FutureBuilder<List<BudgetResponse>>(
                      future: listBudgetPast,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<BudgetResponse>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return BudgetList(listBudget: snapshot.data ?? [], onSave: (value) { 
                            if(value != null && value)
                            {
                              setState(() {
                                listBudget = Budget_Service().GetBudgetWithTime(ParamPudget(
                                  userId: 0,
                                  fromDate: listDateTime.startOfMonth,
                                  toDate: listDateTime.endOfMonth
                                ));
                              });
                            }
                           },);
                        }
                      },
                    ),
                    FutureBuilder<List<BudgetResponse>>(
                      future: listBudget,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<BudgetResponse>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return BudgetList(listBudget: snapshot.data ?? [], onSave: (value) { 
                            if(value != null && value)
                            {
                              setState(() {
                                listBudget = Budget_Service().GetBudgetWithTime(ParamPudget(
                                  userId: 0,
                                  fromDate: listDateTime.startOfMonth,
                                  toDate: listDateTime.endOfMonth
                                ));
                              });
                            }
                           },);
                        }
                      },
                    ),
                    FutureBuilder<List<BudgetResponse>>(
                      future: listBudgetFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<BudgetResponse>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return BudgetList(listBudget: snapshot.data ?? [], onSave: (value) { 
                            if(value != null && value)
                            {
                              setState(() {
                                listBudget = Budget_Service().GetBudgetWithTime(ParamPudget(
                                  userId: 0,
                                  fromDate: listDateTime.startOfMonth,
                                  toDate: listDateTime.endOfMonth
                                ));
                              });
                            }
                           },);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async{
              var result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBudgetPage()),
              );
              if(result != null && result)
              {
                setState(() {
                  listBudget = Budget_Service().GetBudgetWithTime(ParamPudget(
                    userId: 0,
                    fromDate: listDateTime.startOfMonth,
                    toDate: listDateTime.endOfMonth
                  ));
                });
              }
            },
            child: Icon(Icons.add, color: Colors.white),
            mini: true,
            backgroundColor: Colors.pink[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            )));
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
