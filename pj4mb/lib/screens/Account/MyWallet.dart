import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/models/Wallet/WalletType.dart';
import 'package:pj4mb/screens/Account/AddWallet.dart';
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
    walletList = WalletService().GetWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [         
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
                    return ListWallet(
                        listWallet: snapshot.data!,
                        onSave: (value) {
                          setState(() {
                            walletList = WalletService().GetWallet();
                          });
                        });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddWalletPage()));
            if (result) {
              setState(() {
                walletList = WalletService().GetWallet();
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
