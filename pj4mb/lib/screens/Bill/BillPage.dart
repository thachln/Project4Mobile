import 'package:flutter/material.dart';
import 'package:pj4mb/models/Bill/Bill.dart';
import 'package:pj4mb/screens/Bill/AddBill.dart';
import 'package:pj4mb/services/Bill_service.dart';

class BillPage extends StatefulWidget {
  const BillPage({super.key});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> with TickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<Bill>> bill; //= BillService().GetBill();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                  Center(child: Text('Không có dữ liệu')),
                  Center(child: Text('Không có dữ liệu'))
                  // FutureBuilder<List<Bill>>(
                  //   future: bill,
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<List<Bill>> snapshot) {
                  //     if (snapshot.connectionState ==
                  //         ConnectionState.waiting) {
                  //       return Center(child: CircularProgressIndicator());
                  //     } else if (snapshot.hasError) {
                  //       return Center(
                  //           child: Text('Error: ${snapshot.error}'));
                  //     } else {
                  //       if(snapshot.data!.isEmpty){
                  //         return Center(child: Text('Không có dữ liệu'));
                  //       }
                  //       return Center(child: Text('Không có dữ liệu'));
                  //     }
                  //   },
                  // ),
                  // FutureBuilder<List<Bill>>(
                  //   future: bill,
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<List<Bill>> snapshot) {
                  //     if (snapshot.connectionState ==
                  //         ConnectionState.waiting) {
                  //       return Center(child: CircularProgressIndicator());
                  //     } else if (snapshot.hasError) {
                  //       return Center(
                  //           child: Text('Error: ${snapshot.error}'));
                  //     } else {
                  //       if(snapshot.data!.isEmpty){
                  //         return Center(child: Text('Không có dữ liệu'));
                  //       }
                  //       return Center(child: Text('Không có dữ liệu'));
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddBillPage()));
          },
          backgroundColor: Colors.pink[200],
          mini: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );
  }
}
