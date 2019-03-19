import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/ui/main_pages/homepage.dart';

void main() {
  runApp(MoneyTrackerApp());
}

class MoneyTrackerApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Money Tracker",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xff42475d),
        accentColor: Colors.pink,
      ),
      home: HomePage()
    );
  }
}