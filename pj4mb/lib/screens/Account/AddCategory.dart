import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key, required this.categoryType});
  final String categoryType;
  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  late TextEditingController categoryName;
  late TextEditingController categoryIcon;
  late TextEditingController categoryTypeValue;

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
    categoryName = TextEditingController();
    categoryIcon = TextEditingController();
    categoryTypeValue = TextEditingController(text: widget.categoryType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black87,
      appBar: AppBar(
          title: Text(
        "Add new category",
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
                    controller: categoryName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: 'Category Name'),
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
                  child: TextField(
                    readOnly: true,
                    controller: categoryTypeValue,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(Icons.insert_emoticon_outlined),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Chọn icon'),
                          content: Container(
                            width: double.maxFinite,
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: icons.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      categoryIcon.text = icons[index];
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Image.asset(icons[index]),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: categoryIcon.text.isEmpty
                      ? Text('Chọn icon')
                      : Image.asset(
                          categoryIcon.text, // Hiển thị icon đã chọn
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerLeft,
                        ),
                ))
              ],
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
