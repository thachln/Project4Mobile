import 'package:flutter/material.dart';
import 'package:pj4mb/screens/Account/Debt.dart';
import 'package:pj4mb/screens/Account/Group.dart';
import 'package:pj4mb/screens/Home.dart';
import 'package:pj4mb/screens/Introduce.dart';
import 'package:pj4mb/screens/Account/MyWallet.dart';
import 'package:pj4mb/screens/Overview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
