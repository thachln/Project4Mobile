import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyWalletPage extends StatefulWidget {
  const MyWalletPage({super.key});

  @override
  _MyWalletPageState createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> {
  String? selectedWallet; // Thông tin ví đã chọn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
      ),
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
                    trailing: Icon(Icons.arrow_forward_ios), // Mũi tên
                    onTap: () {
                      setState(() {
                        selectedWallet = '1'; //Lưu giá trị ví chọn
                      });
                      Navigator.pop(context, selectedWallet);
                    },
                  );
                }),
          ),
          selectedWallet != null
              ? Text("Ví hiện tại của bạn: $selectedWallet")
              : Container(), // Hiển thị ví đã chọn
          ElevatedButton(
            child: Text("SAVE"),
            onPressed: () {
              Navigator.pop(context, selectedWallet);
            },
          ),
        ],
      ),
    );
  }
}
