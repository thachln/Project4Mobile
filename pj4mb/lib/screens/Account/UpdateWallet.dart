import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Category/Cat_Icon.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/models/Wallet/WalletType.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class UpdateWalletPage extends StatefulWidget {
  const UpdateWalletPage({super.key, required this.walletName, required this.balance, required this.walletTypeIDParam, required this.currency, required this.walletID});
  final int walletID;
  final String walletName;
  final double balance;
  final int walletTypeIDParam;
  final String currency;
  @override
  State<UpdateWalletPage> createState() => _UpdateWalletPageState();
}

class _UpdateWalletPageState extends State<UpdateWalletPage> {
  late TextEditingController walletName;
  late TextEditingController balance;
  late TextEditingController walletType;
  late TextEditingController walletTypeId;
  late TextEditingController currency;
  late Future<List<WalletType>> listWalletType;
  late Future<WalletType> WalletTypeFirst;
  String dropdownValue = 'VND';
  WalletType? selectedWalletType;

  List<String> icons = [
    'assets/icon/anotherbill.png',
    'assets/icon/beauty.png',
    'assets/icon/bill&fees.png',
    'assets/icon/business.png',
    'assets/icon/drink.png',
    'assets/icon/education.png',
    'assets/icon/entertainment.png',
    'assets/icon/extraincome.png',
    'assets/icon/food.png',
    'assets/icon/gift.png',
    'assets/icon/grocery.png',
    'assets/icon/home.png',
    'assets/icon/homebill.png',
    'assets/icon/loan.png',
    'assets/icon/other.png',
    'assets/icon/phonebill.png',
    'assets/icon/salary.png',
    'assets/icon/shopping.png',
    'assets/icon/transport.png',
    'assets/icon/travel.png',
    'assets/icon/waterbill.png'
  ];

  @override
  void initState() {
    super.initState();
    walletName = TextEditingController();
    balance = TextEditingController();
    walletType = TextEditingController();
    currency = TextEditingController();
    walletTypeId = TextEditingController();
    loadWalletTypeFirst();
  }

  void loadWalletTypeFirst() async {
  listWalletType =  WalletService().GetWalletType();
  print(widget.walletTypeIDParam);
  WalletTypeFirst = WalletService().GetWalletTypeWithID(widget.walletTypeIDParam); // Future<WalletType>
  WalletTypeFirst.then((walletTypeResult) {
    // Cập nhật giá trị được chọn trên giao diện người dùng sau khi được tải từ API
    setState(() {
      selectedWalletType = walletTypeResult;
      print(selectedWalletType!.toJson());
    });
  });
  }
  
  @override
  Widget build(BuildContext context) {
    walletName.text = widget.walletName;
    balance.text = widget.balance.toString();
    
    currency.text = widget.currency;

    return Scaffold(
      //backgroundColor: Colors.black87,
      appBar: AppBar(
          title: Text(
        "Add new wallet",
      )),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        //color :Colors.grey[500],
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.question_mark_outlined),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: walletName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: 'Wallet Name'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(Icons.numbers),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: balance,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Balace Name'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(Icons.currency_exchange_rounded),
                SizedBox(
                  width: 10,
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['VND', 'USD']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(Icons.exposure),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FutureBuilder<List<WalletType>>(
                    future: listWalletType,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<WalletType>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return DropdownButtonFormField<WalletType>(
                          decoration: InputDecoration(
                            hintText: 'Wallet Type',
                          ),
                          value: null,
                          onChanged: (WalletType? value) {
                            setState(() {
                              walletType.text = value!.TypeName;
                              walletTypeId.text = value!.TypeID.toString();
                            });
                          },
                          items: snapshot.data!.map((WalletType value) {
                            return DropdownMenuItem<WalletType>(
                              value: value,
                              child: Text(value.TypeName),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                Wallet wallet = Wallet(
                  walletID: 0,
                  walletName: walletName.text,
                  balance: double.parse(balance.text),
                  walletTypeID: int.parse(walletTypeId.text),
                  currency: dropdownValue,
                  userId: 0,
                  bankName: '',
                  bankAccountNum: '',
                );
                var result = await WalletService().InsertWallet(wallet);
                if (result) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Thông báo'),
                        content: Text('Insert success!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                              Navigator.pop(context, true);
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
                        title: Text('Thông báo'),
                        content: Text('Error: Insert fail!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
