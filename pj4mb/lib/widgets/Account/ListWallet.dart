import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/SavingGoal/SavingGoal.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/models/Wallet/WalletType.dart';
import 'package:pj4mb/screens/Account/UpdateWallet.dart';
import 'package:pj4mb/services/SavingGoal_service.dart';
import 'package:pj4mb/services/Wallet_service.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class ListWallet extends StatefulWidget {
  const ListWallet({super.key, required this.listWallet, required this.onSave});
  final List<Wallet> listWallet;
  final void Function(dynamic value) onSave;

  @override
  State<ListWallet> createState() => _ListWalletState();
}

class _ListWalletState extends State<ListWallet> {
  TextEditingController amountController = TextEditingController();
  TextEditingController transferController = TextEditingController();
  late List<Wallet> listWalletVND;
  final formatter = NumberFormat("#,###");
  late int walletIdDestination = 0;
  late int walletTypeIdDestination = 0;
  late List<WalletType> listWalletType;
  final String url =
      'https://portal.vietcombank.com.vn/Usercontrols/TVPortal.TyGia/pXML.aspx?b=10';
  late List<SavingGoal> listSavingGoal;
  late int? goalId;

  @override
  void initState() {
    super.initState();
    listWalletVND = widget.listWallet
        .where((element) => element.currency == "VND")
        .toList();
    fetchAndParseXml();
    loadData();
    goalId = null;
  }

  Future<void> loadData() async {
    listWalletType = await WalletService().GetWalletType();
    listSavingGoal = await SavingGoalService().GetGoal();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
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
                                      walletID:
                                          int.parse(wallet.walletID.toString()),
                                      walletName: wallet.walletName,
                                      balance: wallet.balance,
                                      walletTypeIDParam: wallet.walletTypeID,
                                      currency: wallet.currency,
                                    )));
                        if (result) {
                          widget.onSave(result);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                            leading:
                                Icon(Icons.account_balance_wallet_outlined),
                            title: Text(wallet.walletName),
                            subtitle: Text(wallet.currency +
                                " | " +
                                formatter.format(wallet.balance)),
                            trailing: Container(
                              width: 96,
                              child: Row(
                                children: [
                                  if (wallet.currency.trim() == "USD")
                                    IconButton(
                                        onPressed: () async {
                                          var walletGoal = listWalletType
                                              .where((element) =>
                                                  element.TypeName == "Goals")
                                              .first;
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {

                                              return StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      StateSetter
                                                          setStateDialog) {
                                                return AlertDialog(
                                                  title: Text('Transfer Money'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text('Amount (USD): '),
                                                        TextField(
                                                          controller:
                                                              amountController,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: 'Amount',
                                                          ),
                                                        ),
                                                        Text(
                                                            'Exchange Rate: 1 USD = ? VND'),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text('1 USD = '),
                                                            Container(
                                                              width: 50,
                                                              child: TextField(
                                                                controller:
                                                                    transferController,
                                                              ),
                                                            ),
                                                            Text(' VND')
                                                          ],
                                                        ),
                                                        Text('Transfer to: '),
                                                        DropdownButtonFormField<
                                                            Wallet>(
                                                          onTap: () {},
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: 'Wallet',
                                                          ),
                                                          value: null,
                                                          onChanged:
                                                              (Wallet? value) {
                                                            setStateDialog(() {
                                                              walletIdDestination =
                                                                  value!
                                                                      .walletID;
                                                              walletTypeIdDestination =
                                                                  value
                                                                      .walletTypeID;
                                                              
                                                            });
                                                          },
                                                          items: listWalletVND
                                                              .map((Wallet
                                                                  value) {
                                                            return DropdownMenuItem<
                                                                Wallet>(
                                                              value: value,
                                                              child: Text(value
                                                                  .walletName),
                                                            );
                                                          }).toList(),
                                                        ),
                                                        if (walletTypeIdDestination ==
                                                            walletGoal
                                                                .TypeID) ...[
                                                          Text('Select Goal'),
                                                          DropdownButtonFormField<
                                                              SavingGoal>(
                                                            decoration:
                                                                InputDecoration(
                                                              hintText: 'GOAL',
                                                            ),
                                                            value: null,
                                                            onChanged:
                                                                (SavingGoal?
                                                                    value) {
                                                              setStateDialog(
                                                                  () {
                                                                goalId =
                                                                    value!.id;
                                                              });
                                                            },
                                                            items: listSavingGoal
                                                                .map((SavingGoal
                                                                    value) {
                                                              return DropdownMenuItem<
                                                                  SavingGoal>(
                                                                value: value,
                                                                child: Text(
                                                                    value.name),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ]
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Transfer'),
                                                      onPressed: () async {
                                                        if (amountController
                                                            .text.isEmpty) {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Information'),
                                                                content: Text(
                                                                    'Amount is required!'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                    },
                                                                    child: Text(
                                                                        'OK'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          return;
                                                        }
                                                        if (transferController
                                                            .text.isEmpty) {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Information'),
                                                                content: Text(
                                                                    'Exchange rate is required!'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                    },
                                                                    child: Text(
                                                                        'OK'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          return;
                                                        }
                                                        if (walletIdDestination ==
                                                            0) {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Information'),
                                                                content: Text(
                                                                    'Destination wallet is required!'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                    },
                                                                    child: Text(
                                                                        'OK'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          return;
                                                        }
                                                        if (walletTypeIdDestination ==
                                                            walletGoal.TypeID) {
                                                          if (goalId == null) {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Information'),
                                                                  content: Text(
                                                                      'Goal wallet is required!'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context,
                                                                            true);
                                                                      },
                                                                      child: Text(
                                                                          'OK'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                            return;
                                                          }
                                                        }
                                                        WalletExchange exchange = WalletExchange(
                                                            userId: 0,
                                                            sourceWalletId:
                                                                wallet.walletID,
                                                            destinationWalletId:
                                                                walletIdDestination,
                                                            amount: double.parse(
                                                                amountController
                                                                    .text),
                                                            exchangeRate: double.parse(
                                                                transferController
                                                                    .text
                                                                    .replaceAll(
                                                                        ',',
                                                                        '')),
                                                            savingGoalId:
                                                                goalId);
                                                        var result =
                                                            await WalletService()
                                                                .Transfer(
                                                                    exchange);
                                                        if (result.status ==
                                                            200) {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Information'),
                                                                content: Text(
                                                                    'Transfer success!'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                      widget.onSave(
                                                                          result);
                                                                    },
                                                                    child: Text(
                                                                        'OK'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        } else {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Information'),
                                                                content: Text(
                                                                    '${result.message}'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                    },
                                                                    child: Text(
                                                                        'OK'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                            },
                                          );
                                        },
                                        icon:
                                            Icon(Icons.change_circle_outlined))
                                  else
                                    SizedBox(
                                      width: 47,
                                    ),
                                  IconButton(
                                      onPressed: () {
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
                                                    var result =
                                                        await WalletService()
                                                            .DeleteWallet(wallet
                                                                .walletID);
                                                    if (result) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Information'),
                                                            content: Text(
                                                                'Delete success!'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      true);
                                                                  Navigator.pop(
                                                                      context,
                                                                      true);
                                                                  widget.onSave(
                                                                      result);
                                                                },
                                                                child:
                                                                    Text('OK'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Information'),
                                                            content: Text(
                                                                'Delete fail!'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      true);
                                                                  Navigator.pop(
                                                                      context,
                                                                      true);
                                                                },
                                                                child:
                                                                    Text('OK'),
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
                                      icon: Icon(Icons.delete_forever_outlined,
                                          color: Colors.red, size: 30)),
                                ],
                              ),
                            )),
                      ),
                    ),
                    SizedBox(height: 6)
                  ],
                );
              });
        }
      },
    );

    ;
  }

  Future<void> fetchAndParseXml() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(response.body);
        final exrateElements = document.findAllElements('Exrate');
        var exchangeUSD = exrateElements
            .where((element) => element.getAttribute('CurrencyCode') == 'USD');
        for (var element in exchangeUSD) {
          transferController.text = element.getAttribute('Buy')!;
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
