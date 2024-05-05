import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/models/Budget/ListDateTime.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Expense/Expense.dart';
import 'package:pj4mb/models/Transaction/Transaction.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Account/Debt.dart';
import 'package:pj4mb/screens/Account/MyWallet.dart';
import 'package:pj4mb/screens/Transaction/TransactionsScreen.dart';
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
  late ListDateTime listDateTime;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    walletList = WalletService().GetWallet();
    
    transactionListTop5NewTransaction = TransactionService().getTop5NewTransaction();
    listDateTime = getFullDays(DateTime.now());
    ParamPudget paramThisWeek = new ParamPudget(
        userId: 0,
        fromDate: listDateTime.startOfWeek,
        toDate: listDateTime.endOfWeek);
     ParamPudget paramThisMonth = new ParamPudget(
        userId: 0,
        fromDate: listDateTime.startOfMonth,
        toDate: listDateTime.endOfMonth);
    transactionListTop5 = TransactionService().getTop5TransactionHightestMoney(paramThisWeek);
    transactionListTop5Month = TransactionService().getTop5TransactionHightestMoney(paramThisMonth);
    getTransactionReportThisWeek = TransactionService().GetTransactionReport(paramThisWeek);
    getTransactionReportThisMonth = TransactionService().GetTransactionReportMonth(paramThisMonth);
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
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
                        Text('Ví của tôi',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyWalletPage(flag: true,)));
                          },
                          child: Text('Xem tất cả',
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
                  Text('Báo cáo chi tiêu',
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
                child:  Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TabBar(
                            controller: _tabController,
                            tabs: [
                              Tab(text: 'Tuần'),
                              Tab(text: 'Tháng'),
                            ],
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                FutureBuilder<List<dynamic>>(
                                  future: Future.wait([transactionListTop5, getTransactionReportThisWeek]) ,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<dynamic>> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else {                                

                                        List<TransactionView> listTransactionTop5 = snapshot.data![0];
                                        List<TransactionReport> listTransactionReport = snapshot.data![1];                                       
                                      return ListWithTime(
                                        listTransactionTop5: listTransactionTop5, 
                                        listTransactionReport: listTransactionReport,
                                      );
                                    }
                                  },
                                ),
                                FutureBuilder<List<dynamic>>(
                                  future: Future.wait([transactionListTop5Month, getTransactionReportThisMonth]) ,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<dynamic>> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else {                                

                                        List<TransactionView> listTransactionTop5 = snapshot.data![0];
                                        List<TransactionReport> listTransactionReport = snapshot.data![1];                                       
                                      return ListOverviewMonth(
                                        listTransactionTop5: listTransactionTop5, 
                                        listTransactionReport: listTransactionReport,
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
                  Text('Giao dịch gần đây',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionsScreen()));
                    },
                    child: Text('Xem tất cả'),
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
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else {
                                      return ListTop5NewTransaction(
                                        listTransactionTop5: snapshot.data!
                                      );
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
