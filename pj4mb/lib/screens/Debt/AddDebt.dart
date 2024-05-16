
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Debt/Debt.dart';
import 'package:pj4mb/models/Transaction/Transaction.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/screens/ThousandsSeparatorInputFormatter.dart';
import 'package:pj4mb/services/Debt_service.dart';

class AddDebtPage extends StatefulWidget {
  const AddDebtPage({super.key});

  @override
  State<AddDebtPage> createState() => _AddDebtPageState();
}

class _AddDebtPageState extends State<AddDebtPage> {
  TextEditingController name = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController creditor = TextEditingController();
  TextEditingController notes = TextEditingController();
  int categoryId = 0;
  String categoryName = '';
  CateTypeENum categoryType = CateTypeENum.DEBT;
  late DateTime dueDate =  DateTime.now();
  late DateTime paidDate =  DateTime.now();
  Category? valueCate;

  Future<void> _selectdueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
        
      });
    }
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Debt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.abc_outlined),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: name,
                    maxLength: 25,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: 'Name'),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Icon(Icons.category),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () async {
                    valueCate = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryPage(
                                  Type:"Debt",
                                )));
                    setState(() {
                      if (valueCate != null) {
                        // Update here using the selected category name
                        categoryName = valueCate!.name;
                        categoryId = valueCate!.categoryID;
                      }
                    });
                  },
                  child: categoryName.trim().isEmpty
                      ? Text('Choose category')
                      : Text(categoryName),
                ))
              ],
            ),
                 SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(Icons.abc_outlined),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: creditor,
                    maxLength: 25,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Creditor'),
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
                    controller: amount,
                     inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                        LengthLimitingTextInputFormatter(14)
                      ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Amount'),
                  ),
                )
              ],
            ),
            SizedBox(height: 25,),
            Row(
                children: [
                  Icon(Icons.calendar_month_sharp),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      await _selectdueDate(context);
                    },
                    child: Text(DateFormat('dd-MM-yyyy').format(dueDate)),
                  ))
                ],
              ),
              SizedBox(
                height: 25,
              ),
             
            ElevatedButton(
              onPressed: () async {
                if(name.text.isEmpty){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
                        content: Text('Name is required!'),
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
                  return;
                
                }
                if(categoryId == 0){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
                        content: Text('Category is required!'),
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
                  return;
                
                }
                if(creditor.text.isEmpty){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
                        content: Text('Creditor is required!'),
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
                  return;
                }
                if(amount.text.isEmpty){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
                        content: Text('Amount is required!'),
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
                  return;       
                }
                if(double.parse(amount.text.replaceAll(',', '')) <= 0)
                {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
                        content: Text('Amount must be greater than 0!'),
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
                  return;       
                }
                Debt debt = new Debt(
                    name: name.text,
                    amount: double.parse(amount.text.replaceAll(',', '')),
                    creditor: creditor.text,
                    notes: notes.text,
                    categoryId: categoryId, id: 0, userId: 0, dueDate: dueDate, paidDate: null, isPaid: false);
                var result = await DebthService().InsertDebt(debt);
                if (result.status == 201) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
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
                        title: Text('Arlet'),
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
