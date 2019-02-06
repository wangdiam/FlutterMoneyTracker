import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/ui/main_pages/homepage.dart';
import 'package:flutter_money_tracker/ui/main_pages/settingspage.dart';
import 'package:flutter_money_tracker/ui/planning_pages/planningpage.dart';
import 'package:flutter_money_tracker/ui/statistics_pages/statisticspage.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: ListView(
            children: <Widget>[
              DrawerHeader(
                  child: Container(
                      child: Stack(
                          children: <Widget>[
                            Center(
                              child: Text(
                                "Money Tracker",
                                style: TextStyle(fontSize: 24.0, color: Colors.white),
                              ),
                            ),
                          ])),
                  decoration: BoxDecoration(color: Colors.blue)),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text("Planning"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,MaterialPageRoute(builder: (context) => PlanningPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance),
                title: Text("Statistics"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())).then((context) {

                  });
                },
              )
            ]
        ));
  }
}