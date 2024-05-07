import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/models/Budget/ListDateTime.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
import 'package:pj4mb/screens/Transaction/FindTransaction.dart';
import 'package:pj4mb/services/Transacsion_service.dart';
import 'package:pj4mb/widgets/Transactions/History.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<TransactionData>> listTransactionThisMonth;
  late Future<List<TransactionData>> listTransactionLastMonth;
  late ListDateTime listDateTimeThisMonth;
  late ListDateTime listDateTimeLastMonth;
  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController với this vì nó là TickerProvider
    _tabController = TabController(initialIndex: 1, length: 2, vsync: this);
    listDateTimeThisMonth = getFullDays(DateTime.now());
    listDateTimeLastMonth =
        getFullDays(DateTime.now().subtract(Duration(days: 30)));
    ParamPudget paramThisMonth = ParamPudget(
        userId: 0,
        fromDate: listDateTimeThisMonth.startOfMonth,
        toDate: listDateTimeThisMonth.endOfMonth);
    ParamPudget paramLastMonth = ParamPudget(
        userId: 0,
        fromDate: listDateTimeLastMonth.startOfMonth,
        toDate: listDateTimeLastMonth.endOfMonth);
    listTransactionThisMonth =
        TransactionService().GetTransactionWithTime(paramThisMonth);
    listTransactionLastMonth =
        TransactionService().GetTransactionWithTime(paramLastMonth);
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
        title: Text("List Transaction"),
        actions: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    switch (result) {
                      case 'view':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FindTransaction(
                                    )));
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'view',
                      child: Text('Xem thêm giao dịch'),
                    ),
                  ],
                  icon: Icon(Icons.more_horiz),
                  tooltip: 'More',
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
         
          Expanded(
            child: Container(
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
                      Tab(text: 'Tháng trước'),
                      Tab(text: 'Tháng này'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        FutureBuilder<List<TransactionData>>(
                          future: listTransactionLastMonth,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<TransactionData>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              return HistoryWidgets(
                                listTransaction: snapshot.data!,
                                onSave: (value) {
                                  if (value != null && value) {
                                    setState(() {
                                      listTransactionThisMonth =
                                          TransactionService()
                                              .GetTransactionWithTime(
                                                  ParamPudget(
                                                      userId: 0,
                                                      fromDate:
                                                          listDateTimeThisMonth
                                                              .startOfMonth,
                                                      toDate:
                                                          listDateTimeThisMonth
                                                              .endOfMonth));
                                      listTransactionLastMonth =
                                          TransactionService()
                                              .GetTransactionWithTime(
                                                  ParamPudget(
                                                      userId: 0,
                                                      fromDate:
                                                          listDateTimeLastMonth
                                                              .startOfMonth,
                                                      toDate:
                                                          listDateTimeLastMonth
                                                              .endOfMonth));
                                    });
                                  }
                                },
                              );
                            }
                          },
                        ),
                        FutureBuilder<List<TransactionData>>(
                          future: listTransactionThisMonth,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<TransactionData>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              return HistoryWidgets(
                                listTransaction: snapshot.data!,
                                onSave: (value) {
                                  if (value != null && value) {
                                    setState(() {
                                      listTransactionThisMonth =
                                          TransactionService()
                                              .GetTransactionWithTime(
                                                  ParamPudget(
                                                      userId: 0,
                                                      fromDate:
                                                          listDateTimeThisMonth
                                                              .startOfMonth,
                                                      toDate:
                                                          listDateTimeThisMonth
                                                              .endOfMonth));
                                      listTransactionLastMonth =
                                          TransactionService()
                                              .GetTransactionWithTime(
                                                  ParamPudget(
                                                      userId: 0,
                                                      fromDate:
                                                          listDateTimeLastMonth
                                                              .startOfMonth,
                                                      toDate:
                                                          listDateTimeLastMonth
                                                              .endOfMonth));
                                    });
                                  }
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
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
