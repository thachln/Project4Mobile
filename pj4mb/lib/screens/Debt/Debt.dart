import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late Future<List<Debt>> debtActive;
  late Future<List<Debt>> debtPaid;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    debtActive = DebthService().findDebtActive();
    debtPaid = DebthService().findDebtPaid();
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
        title: Text('Debt'),
        actions: [
          ElevatedButton(onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReportDebt()));
          }, child: Text('Xem báo cáo'))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 200),
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
                  Tab(text: 'Chưa trả'),
                  Tab(text: 'Đã trả'),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height - 120,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                      child: FutureBuilder<List<Debt>>(
                        future: debtActive,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Debt>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return ListDebt(
                              onSave: (value) {
                                setState(() {
                                  debtActive = DebthService().findDebtActive();
                                  debtPaid = DebthService().findDebtPaid();
                                });
                              },
                              listDebt: snapshot.data!, flag: 0,
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                      child: FutureBuilder<List<Debt>>(
                        future: debtPaid,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Debt>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return ListDebt(
                              onSave: (value) {
                                setState(() {
                                  debtActive = DebthService().findDebtActive();
                                  debtPaid = DebthService().findDebtPaid();
                                });
                              },
                              listDebt: snapshot.data!,flag: 1
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          mini: true,
          child: Icon(Icons.add),
          onPressed: () async {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddDebtPage()));
            if (result) {
              setState(() {
                debtActive = DebthService().findDebtActive();
                debtPaid = DebthService().findDebtPaid();
              });
            }
          },
          backgroundColor: Colors.pink[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );
  }
}
