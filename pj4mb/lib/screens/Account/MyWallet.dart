import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyWalletPage extends StatelessWidget {
  const MyWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Wallet'),),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tính vào tổng',
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ),
          Container(
            color: Colors.blueGrey[200],
            child: ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text('Avatar'),
                    title: Text('1'),
                    subtitle: Text('ID:'),
                    trailing: Container(
                        width: 150,
                        child: Row(
                          children: [],
                        )),
                  );
                }),
          )
        ],
      ),
    );
  }
}
