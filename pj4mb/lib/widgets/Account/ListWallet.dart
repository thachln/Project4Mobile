import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';

class ListWallet extends StatefulWidget {
  const ListWallet({super.key, required this.listWallet});
  final List<Wallet> listWallet; 
  @override
  State<ListWallet> createState() => _ListWalletState();
}

class _ListWalletState extends State<ListWallet> {
   
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                itemCount: widget.listWallet.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Wallet wallet = widget.listWallet[index];
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                         color: Colors.blueGrey[200],
                        child: ListTile(
                          title: Text(wallet.walletName),
                          subtitle: Text(wallet.balance.toString()),
                          trailing: Icon(Icons.more_vert_outlined), // Mũi tên
                          onTap: () {
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(height: 6)
                    ],
                  );
                });
  }
}