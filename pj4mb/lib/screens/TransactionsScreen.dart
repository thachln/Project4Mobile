import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/models/Budget/ListDateTime.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
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
    _tabController = TabController(initialIndex: 1,length: 2, vsync: this);
    listDateTimeThisMonth = getFullDays(DateTime.now());
    listDateTimeLastMonth = getFullDays(DateTime.now().subtract(Duration(days: 30)));
    ParamPudget paramThisMonth = ParamPudget(
        userId: 0,
        fromDate: listDateTimeThisMonth.startOfMonth,
        toDate: listDateTimeThisMonth.endOfMonth);
    ParamPudget paramLastMonth = ParamPudget(
        userId: 0,
        fromDate: listDateTimeLastMonth.startOfMonth,
        toDate: listDateTimeLastMonth.endOfMonth);    
    listTransactionThisMonth = TransactionService().GetTransactionWithTime(paramThisMonth);
    listTransactionLastMonth = TransactionService().GetTransactionWithTime(paramLastMonth);
  }

  @override
  void dispose() {
    // Giải phóng TabController khi State bị loại bỏ
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Số dư',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '1,000,000đ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.search),
                          tooltip: 'Tìm kiếm',
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_horiz),
                          tooltip: 'More',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                      // Đặt controller cho TabBarView để đồng bộ với TabBar
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
                              return HistoryWidgets(listTransaction: snapshot.data!);
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
                              return HistoryWidgets(listTransaction: snapshot.data!);
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
