import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Debt/Debt.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/services/Debt_service.dart';

class UpdateDebtPage extends StatefulWidget {
  const UpdateDebtPage({super.key, required this.debt, required this.flag});
  final Debt debt;
  final int flag;
  @override
  State<UpdateDebtPage> createState() => _UpdateDebtPageState();
}

class _UpdateDebtPageState extends State<UpdateDebtPage> {
  TextEditingController name = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController creditor = TextEditingController();
  TextEditingController notes = TextEditingController();

  int categoryId = 0;
  String categoryName = '';
  late DateTime dueDate = DateTime.now();
  late DateTime? paidDate = DateTime.now();
  CategoryResponse? valueCate;
  bool isPaid = false;
  Future<void> _selectdueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  Future<void> _selectpaidDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: paidDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != paidDate) {
      setState(() {
        paidDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.debt.name;
    amount.text = widget.debt.amount.toString();
    creditor.text = widget.debt.creditor;
    notes.text = widget.debt.notes;
    dueDate = widget.debt.dueDate;
    paidDate = widget.debt.paidDate != null ? widget.debt.paidDate! : null;
    LoadCategory();
  }

  void LoadCategory() async {
    valueCate =
        await CategoryService().GetCategoryWithId(widget.debt.categoryId);
    setState(() {
      if (valueCate != null) {
        categoryName = valueCate!.name;
        categoryId = valueCate!.categoryID;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.flag == 0){
      return Scaffold(
      appBar: AppBar(title: Text('Update Debt'), actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm?'),
                    content: Text('Are you sure to delete this bill ?'),
                    actions: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm?'),
                                content: Text('Are you sure delete it ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      var result = await DebthService()
                                          .DeleteDebt(widget.debt.id);
                                      if (result.status == 200) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Information'),
                                              content: Text('Delete success!'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, true);
                                                    Navigator.pop(
                                                        context, true);
                                                   
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
                                              title: Text('Information'),
                                              content: Text('Delete fail!'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, true);
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                  child: Text('OK'),
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
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  );
                },
              );
            })
      ]),
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
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: 'Name'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
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
                                  flag: 2,
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
                      ? Text('Chọn nhóm')
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
                    keyboardType: TextInputType.text,
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
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Amount'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
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
            CheckboxListTile(
                title: Text("Paid"),
                value: isPaid,
                onChanged: (val) {
                  setState(() {
                    isPaid = val!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading),
            ElevatedButton(
              onPressed: () async {
                Debt debt = new Debt(
                    name: name.text,
                    amount: double.parse(amount.text),
                    creditor: creditor.text,
                    notes: notes.text,
                    categoryId: categoryId,
                    id: widget.debt.id,
                    userId: 0,
                    dueDate: dueDate,
                    paidDate: null,
                    isPaid: isPaid);
                if (isPaid) debt.paidDate = DateTime.now();

                var result = await DebthService().UpdateDebt(debt);
                if (result.status == 200) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Thông báo'),
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
                        title: Text('Thông báo'),
                        content: Text('Error: Update fail! ${result.message}'),
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
              child: Text('Update'),
            )
          ],
        ),
      ),
    );
    }
    else{
      return Scaffold(
      appBar: AppBar(title: Text('Information Debt')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.question_mark_outlined),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: name,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: 'Name'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
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
                    // valueCate = await Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => CategoryPage(
                    //               flag: 2,
                    //             )));
                    // setState(() {
                    //   if (valueCate != null) {
                    //     // Update here using the selected category name
                    //     categoryName = valueCate!.name;
                    //     categoryId = valueCate!.categoryID;
                    //   }
                    // });
                  },
                  child: categoryName.trim().isEmpty
                      ? Text('Chọn nhóm')
                      : Text(categoryName),
                ))
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(Icons.question_mark_outlined),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: creditor,
                    keyboardType: TextInputType.text,
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
                Icon(Icons.question_mark_outlined),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Amount'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Text("Due Date: " + DateFormat('dd-MM-yyyy').format(dueDate)),
            SizedBox(
              height: 25,
            ),
            Text(paidDate != null ? "Paid Date: " + DateFormat('dd-MM-yyyy').format(paidDate!) : "")          
          ],
        ),
      ),
    );
    }
    
  }
}
