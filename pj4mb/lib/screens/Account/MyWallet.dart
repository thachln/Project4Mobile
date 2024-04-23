import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/services/Wallet_service.dart';
import 'package:pj4mb/widgets/Account/ListWallet.dart';

class MyWalletPage extends StatefulWidget {
  const MyWalletPage({super.key});

  @override
  _MyWalletPageState createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> {
  String? selectedWallet; // Thông tin ví đã chọn
  late Future<List<Wallet>> walletList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletList = WalletService().GetWallet("1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
      ),
      body: Column(
        children: [
          // SizedBox(
          //   height: 40,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Tính vào tổng',
          //         textAlign: TextAlign.left,
          //       )
          //     ],
          //   ),
          // ),
          Container(
            child: FutureBuilder<List<Wallet>>(
              future: walletList,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Wallet>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListWallet(listWallet: snapshot.data!);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {},
          backgroundColor: Colors.pink[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );
  }
}
