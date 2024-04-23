import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/screens/Login.dart';
import 'package:pj4mb/screens/SignUp.dart';

class IntroducePage extends StatefulWidget {
  const IntroducePage({super.key});

  @override
  State<IntroducePage> createState() => _IntroducePageState();
}

class _IntroducePageState extends State<IntroducePage> {
  final List<String> imageList = [
    'assets/images/1.PNG',
    'assets/images/2.PNG',
    'assets/images/3.png'
  ];
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [Icon(Icons.money), Text('Money Lover')],
        )),
        body: Padding(
          padding: const EdgeInsets.all(46.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.4,
                child: PageView.builder(
                  itemCount: imageList.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.asset(
                      imageList[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  imageList.length,
                  (int index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      height: 10,
                      width: _currentPage == index ? 30 : 10,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            _currentPage == index ? Colors.blue : Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.green), 
                    foregroundColor: MaterialStateProperty.all(
                        Colors.white), 
                  ),
                  child: Text('Đăng ký'),
                ),
              ),
              ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              }, child: Text('Đăng nhập'))
            ],
          ),
        ));
  }
}
