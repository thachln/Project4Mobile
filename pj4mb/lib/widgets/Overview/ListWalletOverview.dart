import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Account/UpdateWallet.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class ListWalletOverview extends StatelessWidget {
  const ListWalletOverview({super.key, required this.listWallet, required this.onSave});
  final List<Wallet> listWallet;
  final void Function(dynamic value) onSave;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: listWallet.length > 2 ? 2 : listWallet.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Wallet wallet = listWallet[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () async {               
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),                 
                  child: ListTile(
                      title: Text(wallet.walletName,style: TextStyle(fontSize: 13),),
                      trailing: Text(wallet.balance.toString() + " ${wallet.currency}",style: TextStyle(fontSize: 13),)
                      ),
                ),
              ),             
            ],
          );
        });
  }
}
