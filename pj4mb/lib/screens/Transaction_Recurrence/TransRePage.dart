import 'package:flutter/material.dart';
import 'package:pj4mb/models/Bill/Bill.dart';
import 'package:pj4mb/models/Bill/BillResponse.dart';
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
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    transRecuActive = TransactionRecurrence_Service().findRecuActive();
    transRecuExpired = TransactionRecurrence_Service().findRecuExpired();
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
                              transRecuActive = TransactionRecurrence_Service()
                                  .findRecuActive();
                              transRecuExpired = TransactionRecurrence_Service()
                                  .findRecuExpired();
                            });
                          },
                        );
                      }
                    },
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
                              transRecuActive = TransactionRecurrence_Service()
                                  .findRecuActive();
                              transRecuExpired = TransactionRecurrence_Service()
                                  .findRecuExpired();
                            });
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
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTranRecuPage()));
            if (result) {
              setState(() {
                transRecuActive =
                    TransactionRecurrence_Service().findRecuActive();
                transRecuExpired =
                    TransactionRecurrence_Service().findRecuExpired();
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
}
