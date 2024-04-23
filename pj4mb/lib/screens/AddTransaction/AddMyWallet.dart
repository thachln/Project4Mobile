import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddMyWalletPage extends StatefulWidget {
  const AddMyWalletPage({super.key});

  @override
  _AddMyWalletPageState createState() => _AddMyWalletPageState();
}

class _AddMyWalletPageState extends State<AddMyWalletPage> {
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
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ListTile(
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
                        ),
                      ),
                      SizedBox(height: 6)
                    ],
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
