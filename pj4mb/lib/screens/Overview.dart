import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Budget/ListDateTime.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Expense/Expense.dart';
import 'package:pj4mb/models/Notification/Notification.dart';
import 'package:pj4mb/models/Transaction/Transaction.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Account/NotificationPage.dart';
import 'package:pj4mb/screens/Debt/Debt.dart';
import 'package:pj4mb/screens/Account/MyWallet.dart';
import 'package:pj4mb/screens/Transaction/TransactionsScreen.dart';
import 'package:pj4mb/services/Notification_service.dart';
import 'package:pj4mb/services/Transacsion_service.dart';
import 'package:pj4mb/services/Wallet_service.dart';
import 'package:pj4mb/widgets/Account/ListWallet.dart';
import 'package:pj4mb/widgets/Overview/ListOverviewMonth.dart';
import 'package:pj4mb/widgets/Overview/ListTop5NewTransaction.dart';
import 'package:pj4mb/widgets/Overview/ListWalletOverview.dart';
import 'package:pj4mb/widgets/Overview/ListOverview.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> with TickerProviderStateMixin {
  TabController? _tabController;
  bool _isObscure = true;
  late Future<List<Wallet>> walletList;
  late Future<List<TransactionView>> transactionListTop5;
  late Future<List<TransactionView>> transactionListTop5Month;
  late Future<List<TransactionView>> transactionListTop5NewTransaction;
  late Future<List<TransactionReport>> getTransactionReportThisWeek;
  late Future<List<TransactionReport>> getTransactionReportThisMonth;
  late Future<List<NotificationDTO>> getNotifaction;
  late List<NotificationDTO> listNotification;
  late int numberNotification = 0;
  late ListDateTime listDateTime;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadNotification();
    walletList = WalletService().GetWallet();
    //getNotifaction = NotificationService().GetNotification();
    transactionListTop5NewTransaction =
        TransactionService().getTop5NewTransaction();
    listDateTime = getFullDays(DateTime.now());
    ParamPudget paramThisWeek = new ParamPudget(
        userId: 0,
        fromDate: listDateTime.startOfWeek,
        toDate: listDateTime.endOfWeek);
    ParamPudget paramThisMonth = new ParamPudget(
        userId: 0,
        fromDate: listDateTime.startOfMonth,
        toDate: listDateTime.endOfMonth);
    transactionListTop5 =
        TransactionService().getTop5TransactionHightestMoney(paramThisWeek);
    transactionListTop5Month =
        TransactionService().getTop5TransactionHightestMoney(paramThisMonth);
    getTransactionReportThisWeek =
        TransactionService().GetTransactionReport(paramThisWeek);
    getTransactionReportThisMonth =
        TransactionService().GetTransactionReportMonth(paramThisMonth);
  }

  void loadNotification() async {
    listNotification = await NotificationService().GetNotification();
    setState(() {
      print(1);
      numberNotification = listNotification.where((element) => element.read == false).length;
    });
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
        title: Row(
          children: [
            Container(
            width: 50,
            height: 50,
            child: Image.asset('assets/images/logo.png'),),
            SizedBox(width: 8),
            Text('Finance Tracking')
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () async {
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationPage(
                                        listNotification: listNotification,
                                      )));
                          if (result) {
                            setState(() {
                              loadNotification();
                            });
                          }
                        },
                      ),
              Positioned(
                right: 11,
                top: 11,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    numberNotification.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('My wallet',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyWalletPage(
                                          flag: true,
                                        )));
                          },
                          child: Text('See all',
                              style: TextStyle(color: Colors.blue)),
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FutureBuilder<List<Wallet>>(
                            future: walletList,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Wallet>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                return ListWalletOverview(
                                    listWallet: snapshot.data!,
                                    onSave: (value) {
                                      setState(() {
                                        walletList =
                                            WalletService().GetWallet();
                                      });
                                    });
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Expense report',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: 'Week'),
                          Tab(text: 'Month'),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            FutureBuilder<List<dynamic>>(
                              future: Future.wait([
                                transactionListTop5,
                                getTransactionReportThisWeek
                              ]),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else {
                                  List<TransactionView> listTransactionTop5 =
                                      snapshot.data![0];
                                  List<TransactionReport>
                                      listTransactionReport = snapshot.data![1];
                                  return ListWithTime(
                                    listTransactionTop5: listTransactionTop5,
                                    listTransactionReport:
                                        listTransactionReport,
                                  );
                                }
                              },
                            ),
                            FutureBuilder<List<dynamic>>(
                              future: Future.wait([
                                transactionListTop5Month,
                                getTransactionReportThisMonth
                              ]),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else {
                                  List<TransactionView> listTransactionTop5 =
                                      snapshot.data![0];
                                  List<TransactionReport>
                                      listTransactionReport = snapshot.data![1];
                                  return ListOverviewMonth(
                                    listTransactionTop5: listTransactionTop5,
                                    listTransactionReport:
                                        listTransactionReport,
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent transactions',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionsScreen()));
                    },
                    child: Text('See all'),
                  )
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: FutureBuilder<List<TransactionView>>(
                  future: transactionListTop5NewTransaction,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TransactionView>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return ListTop5NewTransaction(
                          listTransactionTop5: snapshot.data!);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
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

    ListDateTime listDateTime = ListDateTime(
        startOfWeek: startOfWeek,
        endOfWeek: endOfWeek,
        startOfMonth: startOfMonth,
        endOfMonth: endOfMonth,
        firstDayOfQuarter: DateTime.now(),
        lastDayOfQuarter: DateTime.now(),
        startOfYear: DateTime.now(),
        endOfYear: DateTime.now());
    return listDateTime;
  }
}
