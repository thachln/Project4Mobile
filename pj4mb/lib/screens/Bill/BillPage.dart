import 'package:flutter/material.dart';
import 'package:pj4mb/models/Bill/Bill.dart';
import 'package:pj4mb/models/Bill/BillResponse.dart';
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
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    billActive = BillService().findBillActive();
    billExpired = BillService().findBillExpired();
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
              // Đặt index của tab hiện tại
              onTap: (index) {},
              tabs: [
                Tab(text: 'Đang áp dụng'),
                Tab(text: 'Đã kết thúc'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
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
                        if(snapshot.data!.isEmpty){
                          return Center(child: Text('Không có dữ liệu'));
                        }
                        return BillList(listBill: snapshot.data!, onSave: (value) { 
                          setState(() {
                            billActive = BillService().findBillActive();
                            billExpired = BillService().findBillExpired();
                          });
                         },);
                      }
                    },
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
                        if(snapshot.data!.isEmpty){
                          return Center(child: Text('Không có dữ liệu'));
                        }
                         return BillList(listBill: snapshot.data!, onSave: (value) { 
                           setState(() {
                            billActive = BillService().findBillActive();
                            billExpired = BillService().findBillExpired();
                          });
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
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddBillPage()));
            if(result){
              setState(() {
                billActive = BillService().findBillActive();
                billExpired = BillService().findBillExpired();
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
