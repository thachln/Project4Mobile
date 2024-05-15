import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Category/Cat_Icon.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/models/Wallet/WalletType.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/screens/ThousandsSeparatorInputFormatter.dart';
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class UpdateWalletPage extends StatefulWidget {
  const UpdateWalletPage({
    super.key,
    required this.wallet,
  });
  final Wallet wallet;
  @override
  State<UpdateWalletPage> createState() => _UpdateWalletPageState();
}

class _UpdateWalletPageState extends State<UpdateWalletPage> {
  late TextEditingController walletName;
  late TextEditingController balance;
  late TextEditingController walletType;
  late TextEditingController walletTypeId;
  late TextEditingController currency;
  late TextEditingController bankName;
  late TextEditingController bankNumber;
  late Future<List<WalletType>> listWalletType;
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
    bankName = TextEditingController();
    bankNumber = TextEditingController();
    loadWalletTypeFirst();
  }

  void loadWalletTypeFirst() async {
    listWalletType = WalletService().GetWalletType();
  }

  @override
  Widget build(BuildContext context) {
    walletName.text = widget.wallet.walletName;
    balance.text = NumberFormat('#,##0','en_US').format(widget.wallet.balance);
    currency.text = widget.wallet.currency;
    bankName.text = widget.wallet.bankName;
    bankNumber.text = widget.wallet.bankAccountNum;
    walletTypeId.text = widget.wallet.walletTypeID.toString();

    return Scaffold(
      //backgroundColor: Colors.black87,
      appBar: AppBar(
          title: Text(
        "Update wallet",
      )),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        //color :Colors.grey[500],
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.abc),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    readOnly: widget.wallet.walletTypeID == 3 ? true : false,
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
                Icon(Icons.monetization_on_rounded),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    readOnly: widget.wallet.walletTypeID == 3 ? true : false,
                    controller: balance,
                     inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
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
                        selectedWalletType = snapshot.data!.firstWhere(
                            (element) =>
                                element.TypeID == widget.wallet.walletTypeID);
                        walletType.text = selectedWalletType!.TypeName;
                        walletTypeId.text =
                            selectedWalletType!.TypeID.toString();                     
                        walletType.text = snapshot.data!.where((element) => element.TypeID == widget.wallet.walletTypeID).first.TypeName;
                        return TextField(
                            readOnly: true,
                            controller: walletType,
                            keyboardType: TextInputType.text,
                          );
                        
                      }
                    },
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
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: currency,
                    keyboardType: TextInputType.text,
                  ),
                )
              ],
            ),
            if (walletTypeId.text == "2") ...[
              Row(
                children: [
                  Icon(Icons.abc),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: bankName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Bank Name'),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Icon(Icons.abc),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: bankNumber,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Bank Number'),
                    ),
                  )
                ],
              ),
            ],
            ElevatedButton(
              onPressed: () async {
                Wallet wallet = Wallet(
                  walletID: widget.wallet.walletID,
                  walletName: walletName.text,
                  balance: double.parse(balance.text.replaceAll(',','')),
                  walletTypeID: int.parse(walletTypeId.text),
                  currency: dropdownValue,
                  userId: 0,
                  bankName: bankName.text.isNotEmpty ? bankName.text : '',
                  bankAccountNum:
                      bankNumber.text.isNotEmpty ? bankNumber.text : '',
                );
                print(wallet.toJson());
                var result = await WalletService().UpdateWallet(wallet);
                if (result) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
                        content: Text('Update success!'),
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
                        title: Text('Arlet'),
                        content: Text('Error: Update fail!'),
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
              child: Text('Update Wallet'),
            )
          ],
        ),
      ),
    );
  }
}
