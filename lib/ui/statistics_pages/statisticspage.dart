import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StatisticsPageState();
  }

}

class StatisticsPageState extends State<StatisticsPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("STATISTICS",
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0
          ),),
      ),
      body: Container(
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}