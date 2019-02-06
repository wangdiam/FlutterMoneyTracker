import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/ui/main_pages/addexpenditurepage.dart';
import 'package:flutter_money_tracker/ui/main_pages/allcreditpage.dart';
import 'package:flutter_money_tracker/ui/main_pages/alldebitpage.dart';
import 'package:flutter_money_tracker/ui/main_pages/alltransactionspage.dart';
import 'package:flutter_money_tracker/ui/main_pages/maindrawer.dart';
import 'package:flutter_money_tracker/ui/main_pages/settingspage.dart';
import 'package:flutter_money_tracker/ui/main_pages/transactioninformationpage.dart';
import 'package:flutter_money_tracker/ui/planning_pages/planningpage.dart';
import 'package:flutter_money_tracker/ui/statistics_pages/statisticspage.dart';
import 'package:flutter_money_tracker/utils/database_helper.dart';


import 'package:intl/intl.dart';class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>{
  double moneyLeft = 0;
  var debitList = [];
  var creditList = [];
  List<dynamic> debitListAmounts = [];
  List<dynamic> creditListAmounts = [];
  var db = DatabaseHelper();

  Future<Null> recalculateLimit() async {
    var mLimit = await db.getWeeklyLimit();
    double limit = mLimit[0]['amount'];
    for (int i=0;i<debitList.length;i++) {
      limit = limit + debitList[i]['amount'];
    }
    for (int i=0;i<creditList.length;i++) {
      limit = limit + creditList[i]['amount'];
    }
    setState(() {
      moneyLeft = limit;
      print(moneyLeft);
    });
  }

  Future<Null> getAllDebitHistoryFromDB() async {
    var mList = await db.getAllDebit();
    var mListAmounts = [];
    setState(() {
      print(mList.length);
      debitList = mList.reversed.toList();
      for (int i=0;i<mList.length;i++) {
        double amount = -1*mList[i]['amount'];
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
      for (int i=0;i<mList.length;i++) {
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

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
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
    return Scaffold(
      drawer: Drawer(
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
                      recalculateLimit();
                    });
                  },
                )
              ]
          )),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text('MONEY TRACKER',
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 12.0
        ),),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddExpenditurePage())).then((context) {
              getAllDebitHistoryFromDB();
              getAllCreditHistoryFromDB();
              recalculateLimit();
        });
      },
          child: Icon(Icons.add)),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.indigo[500],
            Colors.indigo[600],
            Colors.indigo[800],
            Colors.indigo[900]
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1,0.5,0.7,0.9])
        ),
        child: SingleChildScrollView(
          child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Material(
                                color: Colors.indigo[500],
                                type: MaterialType.card,
                                borderRadius: BorderRadius.circular(8.0),
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Money left:",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                color: Colors.white
                                              ),
                                            ),
                                            Text((this.moneyLeft >= 0)? ("\$" + "${this.moneyLeft.toStringAsFixed(2)}") : ("-\$" + "${this.moneyLeft.toStringAsFixed(2).substring(1)}"),
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white
                                              ),)
                                          ]),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Opacity(
                                          opacity: 0.2,
                                          child: Container(
                                            color: Colors.white,
                                            height: 1,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AllTransactionsPage()));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Icon(Icons.history,
                                                            color: Colors.white70),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text("Summary",
                                                          style: TextStyle(
                                                              color: Colors.white70
                                                          ),),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsPage()));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Icon(Icons.show_chart,
                                                            color: Colors.white70),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text("Statistics",
                                                          style: TextStyle(
                                                              color: Colors.white70
                                                          ),),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Debit History",
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w100,
                                        color: Colors.white
                                      ),
                                    ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllDebitPage())).then((context){
                                        getAllDebitHistoryFromDB();
                                        getAllCreditHistoryFromDB();
                                        recalculateLimit();
                                      });
                                    },
                                    child: Icon(Icons.arrow_forward_ios,
                                      size: 14.0,
                                      color: Colors.white70,)

                                  )
                                  ],
                                ),
                              ),
                                Center(
                                  child: (debitList.length == 0 || debitList.length == null) ?
                                  Text("You have no debit history",
                                  style: TextStyle(
                                      color: Colors.white70
                                  ),)
                                  : ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                      itemCount: (debitList.length <= 3) ? debitList.length : 3,
                                      itemBuilder: (context,i) => Card(
                                        color: Colors.indigo[400],
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => TransactionInformationPage(debitList[i]['id'])))
                                            .then((context){
                                          getAllDebitHistoryFromDB();
                                          getAllCreditHistoryFromDB();
                                          recalculateLimit();
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(debitList[i]['title'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  fontSize: 16.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("-\$" + debitListAmounts[i].toStringAsFixed(2),
                                                  style: TextStyle(
                                                      color: Colors.white70
                                                  ),),
                                                  Text("${readTimestamp(debitList[i]['time'])}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                      color: Colors.white70
                                                  ),)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  )
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Credit History",
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w100,
                                          color: Colors.white
                                      ),),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AllCreditPage())).then((context){
                                          getAllDebitHistoryFromDB();
                                          getAllCreditHistoryFromDB();
                                          recalculateLimit();
                                        });
                                      },
                                      child: Icon(Icons.arrow_forward_ios,
                                      size: 14.0,
                                      color: Colors.white70,)

                                    )
                                  ],
                                ),
                              ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,60.0),
                                  child: Center(
                                    child: (creditList.length == 0 || creditList.length == null) ?
                                    Text("You have no credit history",
                                    style: TextStyle(
                                        color: Colors.white70
                                    ),)
                                        : ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                        itemCount: (creditList.length <= 3) ? creditList.length : 3,
                                        itemBuilder: (context,i) => Card(
                                          color: Colors.indigo[400],
                                            child: InkWell(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionInformationPage(creditList[i]['id']))).then((context){
                                                  getAllDebitHistoryFromDB();
                                                  getAllCreditHistoryFromDB();
                                                  recalculateLimit();
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(creditList[i]['title'],
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                          color: Colors.white
                                                      ),),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Text("\$" + creditListAmounts[i].toStringAsFixed(2),
                                                          style: TextStyle(
                                                              color: Colors.white70
                                                          ),),
                                                          Text("${readTimestamp(creditList[i]['time'])}",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w300,
                                                                color: Colors.white70
                                                            ),)
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                        )),
                                  ),
                                ),
                            ],
                          ),
                        ),
        ),
      ),
    );
  }
}