import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Account/UpdateWallet.dart';

class ListWallet extends StatefulWidget {
  const ListWallet({super.key, required this.listWallet, required this.onSave});
  final List<Wallet> listWallet;
  @override
  State<ListWallet> createState() => _ListWalletState();
  final void Function(dynamic value) onSave;
}

class _ListWalletState extends State<ListWallet> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.listWallet.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Wallet wallet = widget.listWallet[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateWalletPage(
                                walletID: int.parse(wallet.walletID.toString()),
                                walletName: wallet.walletName,
                                balance: wallet.balance,
                                walletTypeIDParam: wallet.walletTypeID,
                                currency: wallet.currency,
                              )));
                  // if (result) {
                  //   onSave(result);
                  // }
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  color: Colors.blueGrey[200],
                  child: ListTile(
                    title: Text(wallet.walletName),
                    subtitle: Text(wallet.balance.toString()),
                    trailing: Icon(Icons.more_vert_outlined), // Mũi tên
                   
                  ),
                ),
              ),
              SizedBox(height: 6)
            ],
          );
        });
  }
}
