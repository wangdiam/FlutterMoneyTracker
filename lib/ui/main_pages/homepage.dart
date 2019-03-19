import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/ui/main_pages/addexpenditurepage.dart';
import 'package:flutter_money_tracker/ui/main_pages/allcreditpage.dart';
import 'package:flutter_money_tracker/ui/main_pages/alldebitpage.dart';
import 'package:flutter_money_tracker/ui/main_pages/alltransactionspage.dart';
import 'package:flutter_money_tracker/ui/main_pages/settingspage.dart';
import 'package:flutter_money_tracker/ui/main_pages/transactioninformationpage.dart';
import 'package:flutter_money_tracker/ui/planning_pages/planningpage.dart';
import 'package:flutter_money_tracker/ui/statistics_pages/statisticspage.dart';
import 'package:flutter_money_tracker/utils/database_helper.dart';

import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  double moneyLeft = 0;
  double totalIncome = 0;
  double totalExpenses = 0;
  var debitList = [];
  var creditList = [];
  List<dynamic> debitListAmounts = [];
  List<dynamic> creditListAmounts = [];
  var db = DatabaseHelper();

  Future<Null> getAllIncome() async {
    var mIncome = await db.getWeeklyLimit();
    double income = mIncome[0]['amount'];
    print("CREDITLISTLENGTH");
    print(creditList.length);
    for (int i = 0; i < creditList.length; i++) {
      income = income + creditList[i]['amount'];
    }
    setState(() {
      totalIncome = income;
    });
  }

  Future<Null> getAllExpenses() async {
    double expenses = 0;
    var mIncome = await db.getWeeklyLimit();
    print("DEBITLISTLENGTH");
    print(debitList.length);
    for (int i = 0; i < debitList.length; i++) {
      expenses = expenses + debitList[i]['amount'];
    }
    setState(() {
      totalExpenses = (expenses != 0) ? expenses*-1 : 0.00;
    });
  }

  Future<Null> recalculateLimit() async {
    getAllExpenses();
    getAllIncome();
  }

  Future<Null> getAllDebitHistoryFromDB() async {
    var mList = await db.getAllDebit();
    var mListAmounts = [];
    setState(() {
      print(mList.length);
      debitList = mList.reversed.toList();
      for (int i = 0; i < mList.length; i++) {
        double amount = -1 * mList[i]['amount'];
        mListAmounts.add(amount);
        print(mList[i]['amount']);
      }
      debitListAmounts = mListAmounts.reversed.toList();
      print(debitListAmounts);
    });
  }

  Future<Null> getAllCreditHistoryFromDB() async {
    var mList = await db.getAllCredit();
    var mListAmounts = [];
    setState(() {
      creditList = mList.reversed.toList();
      for (int i = 0; i < mList.length; i++) {
        double amount = mList[i]['amount'];
        mListAmounts.add(amount);
        print(mList[i]['amount']);
      }
      creditListAmounts = mListAmounts.reversed.toList();
    });
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDebitHistoryFromDB();
    getAllCreditHistoryFromDB();
    recalculateLimit();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xff42475d),
                Color(0xff3d4256),
                Color(0xff363b4f),
                Color(0xff2d3142),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.5, 0.7, 0.9])),
      child: Container(
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Scaffold(
            backgroundColor: Colors.transparent,
            drawer: Drawer(
                child: ListView(children: <Widget>[
              DrawerHeader(
                  child: Container(
                      child: Stack(children: <Widget>[
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PlanningPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance),
                title: Text("Statistics"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StatisticsPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SettingsPage()))
                      .then((context) {
                    recalculateLimit();
                  });
                },
              )
            ])),
            appBar: AppBar(
              elevation: 2.0,
              backgroundColor: Colors.transparent,
              title: Text(
                'MONEY TRACKER',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.0),
              ),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.pink,
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddExpenditurePage()))
                      .then((context) {
                    getAllDebitHistoryFromDB();
                    getAllCreditHistoryFromDB();
                    recalculateLimit();
                  });
                },
                child: Icon(Icons.add)),
            body: Container(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      headingCard(),
                      SizedBox(height: 16.0,),
                      Material(
                        type: MaterialType.card,
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color(0xff3d4255),
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              debitHistoryHeading(),
                              history("debit"),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0,),
                      Material(
                        type: MaterialType.card,
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color(0xff3d4255),
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              creditHistoryHeading(),
                              history("credit"),
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  headingCard() {
    print("total");
    print(totalIncome+totalExpenses);
    return Material(
      color: Color(0xff3d4255),
      type: MaterialType.card,
      borderRadius: BorderRadius.circular(8.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Income And Expenses",
                    style: TextStyle(fontSize: 16.0, color: Colors.white70,fontWeight: FontWeight.w900),
                  ),
                  IconButton(
                    icon: Icon(Icons.list, color: Colors.white70,),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllTransactionsPage()))
                          .then((context) {
                        getAllDebitHistoryFromDB();
                        getAllCreditHistoryFromDB();
                        recalculateLimit();
                      });
                    },
                  )
                ]),
            SizedBox(height: 24.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Savings",style: TextStyle(
                  color: Colors.white54,
                ),),
                Text("Expenses",style: TextStyle(
                  color: Colors.white54,
                ),),
              ],
            ),
            SizedBox(height: 8.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  (this.totalIncome-this.totalExpenses >= 0)
                      ? ("\$" + "${(this.totalIncome-this.totalExpenses).toStringAsFixed(2)}")
                      : ("-\$" +
                      "${(this.totalIncome-this.totalExpenses).toStringAsFixed(2).substring(1)}"),
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                Text(
                  "\$" + "${this.totalExpenses.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 8.0,),
            LinearProgressIndicator(
              value: (totalExpenses+totalIncome != 0) ? (totalIncome-totalExpenses)/(totalExpenses+totalIncome) : 0.0
            )
          ],
        ),
      ),
    );
  }

  debitHistoryHeading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      child: Padding(
        padding: const EdgeInsets.only(left:8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Debit History",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white70),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AllDebitPage()))
                      .then((context) {
                    getAllDebitHistoryFromDB();
                    getAllCreditHistoryFromDB();
                    recalculateLimit();
                  });
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.0,
                  color: Colors.white70,
                ))
          ],
        ),
      ),
    );
  }

  history(String type) {
    var list;
    var amountType;
    if (type == "debit") {
      list = debitList;
      amountType = debitListAmounts;
    } else {
      list = creditList;
      amountType = creditListAmounts;
    }
    return Center(
      child: (list.length == 0 || list.length == null)
          ? Text(
              "You have no debit history\n\n\n\n",
              style: TextStyle(color: Colors.white70),
            )
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: (list.length <= 3) ? list.length : 3,
              itemBuilder: (context, i) => Container(
                color: Color(0xff3d4255),
                child: InkWell(
                  onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionInformationPage(
                                  list[i]['id']))).then((context) {
                        getAllDebitHistoryFromDB();
                        getAllCreditHistoryFromDB();
                        recalculateLimit();
                      });
                    },
                  child: Padding(
                      padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget> [Text(
                                list[i]['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0,
                                    color: Colors.white),
                              ),
                              Text(
                                (type == "debit") ? "-\$" +
                                    amountType[i].toStringAsFixed(2) : "\$" +
                                    amountType[i].toStringAsFixed(2),
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 16.0),
                              ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                Text(
                                  "${readTimestamp(list[i]['time'])}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white70),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:16.0),
                            child: (i != list.length-1 && i != 2)? Divider(
                              color: Colors.white70,
                            ) : Container(margin: EdgeInsets.only(top:8.0),),
                          )
                        ],
                      ),
                    ),
                ),
              )
      ),
    );
  }

  creditHistoryHeading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      child: Padding(
        padding: const EdgeInsets.only(left:8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Credit History",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white70),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllCreditPage())).then((context) {
                    getAllDebitHistoryFromDB();
                    getAllCreditHistoryFromDB();
                    recalculateLimit();
                  });
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.0,
                  color: Colors.white70,
                ))
          ],
        ),
      ),
    );
  }
}
