import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';

class ListWalletBudget extends StatelessWidget {
  const ListWalletBudget({super.key, required this.listWallet, required this.onSave});
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
                  Navigator.pop(context,wallet);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  color: Colors.blueGrey[200],
                  child: ListTile(
                      title: Text(wallet.walletName),
                      subtitle: Text(wallet.balance.toString()),
                      ),
                ),
              ),
              SizedBox(height: 6)
            ],
          );
        });
  }
}
