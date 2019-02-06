import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/model/weeklyamount.dart';
import 'package:flutter_money_tracker/utils/database_helper.dart';

class SettingsPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingsPageState();
  }

}

class SettingsPageState extends State<SettingsPage>{
  final textfieldController = TextEditingController();
  var db = DatabaseHelper();

  addWeeklyLimit(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 32.0,right: 32.0),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Material(
              child: Container(
                  padding: EdgeInsets.only(left: 24.0,right: 24.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Add Limit",
                                style: TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                          child: TextField(
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true
                            ),
                            controller: textfieldController,
                            decoration:
                            InputDecoration(labelText: "Please enter your weekly limit"),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FlatButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  textfieldController.clear();
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  onPressed: () {
                                    var weeklyAmount = WeeklyAmount(double.tryParse(textfieldController.text));
                                    if (textfieldController.text.length != 0) {
                                      db.saveWeeklyAmount(weeklyAmount);
                                    }
                                    textfieldController.clear();
                                    Navigator.pop(context);
                                  }),
                            ],
                          ),
                        )
                      ])))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SETTINGS",
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0
          ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  showDialog(context: context, builder: (context) => addWeeklyLimit(context),);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,16.0,8.0,16.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Weekly Limit",
                            style: TextStyle(
                                fontWeight: FontWeight.w600
                            ),),
                          Text("Enter your weekly limit here",
                            style: TextStyle(
                                fontWeight: FontWeight.w400
                            ),)
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}