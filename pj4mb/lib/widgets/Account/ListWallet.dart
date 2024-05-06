import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Account/UpdateWallet.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class ListWallet extends StatelessWidget {
  const ListWallet({super.key, required this.listWallet, required this.onSave});
  final List<Wallet> listWallet;
  final void Function(dynamic value) onSave;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listWallet.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Wallet wallet = listWallet[index];
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
                  if (result) {
                    onSave(result);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  
                  child: ListTile(
                      leading: Icon(Icons.account_balance_wallet_outlined),
                      title: Text(wallet.walletName),
                      subtitle: Text(wallet.balance.toString()),
                      trailing: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm?'),
                                content: Text(
                                    'Are you sure to delete this wallet, everything in this wallet will be deleted!'),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      var result = await WalletService()
                                          .DeleteWallet(wallet.walletID);
                                      if (result) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Information'),
                                              content: Text('Delete success!'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, true);
                                                    Navigator.pop(
                                                        context, true);
                                                    onSave(result);
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Information'),
                                              content: Text('Delete fail!'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, true);
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Text('OK'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancle'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(Icons.delete_forever_outlined,
                            color: Colors.red, size: 30),
                      )),
                ),
              ),
              SizedBox(height: 6)
            ],
          );
        });
  }
}
