import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/models/Budget/Budget.dart';
import 'package:pj4mb/models/Budget/ListDateTime.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/screens/page/AddBudgetPage.dart';
import 'package:pj4mb/screens/page/BudgetList.dart';
import 'package:pj4mb/services/Budget_service.dart';
import 'package:pj4mb/widgets/Overview/ListOverview.dart';
import '../aset/custom_arc_180_painter.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<BudgetResponse>> listBudget;
  late ListDateTime listDateTime;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    listDateTime = getFullDays(DateTime.now());
    var param = ParamPudget(
        userId: 0,
        fromDate: listDateTime.startOfMonth,
        toDate: listDateTime.endOfMonth);
    listBudget = Budget_Service().GetBudgetWithTime(param);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  List<Widget> budgetCharts = [
    CustomPaint(
      painter: CustomArc180Painter(
        drwArcs: [
          ArcValueModel(color: Colors.green, value: 20),
          ArcValueModel(color: Colors.orange, value: 30),
          ArcValueModel(color: Colors.red, value: 25),
        ],
        end: 50,
        width: 12,
        bgWidth: 8,
      ),
    ),
  ];

  List<Widget> budgetInfo = [
    Column(
      children: [
        Text(
          "\$100,00",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          "of \$1,0000 budget",
          style: TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ngân sách'),
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
                  Tab(text: 'Tháng này'),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TabBarView(
                  controller: _tabController,
                  children: [
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
                          return BudgetList(listBudget: snapshot.data ?? []);
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBudgetPage()),
              );
            },
            child: Icon(Icons.add, color: Colors.white),
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
