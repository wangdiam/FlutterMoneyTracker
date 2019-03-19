import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/model/entry.dart';
import 'package:flutter_money_tracker/ui/main_pages/addexpenditurepage.dart';
import 'package:flutter_money_tracker/ui/main_pages/transactioninformationpage.dart';
import 'package:flutter_money_tracker/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class AllTransactionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AllTransactionsPageState();
  }
}

class AllTransactionsPageState extends State<AllTransactionsPage> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  int moneyLeft = 0;
  var creditList = [];
  var deletedList = [];
  static double totalCreditAmount = 0;
  static double totalDebitAmount = 0;
  List<dynamic> allAmounts = [];
  var db = DatabaseHelper();

  List<CircularStackEntry> data = <CircularStackEntry>[
    CircularStackEntry(<CircularSegmentEntry>[
      CircularSegmentEntry(100.0, Colors.grey, rankKey: "Data Not Available"),
    ], rankKey: "Summary"),
  ];

  Future<Null> getAllFromDB() async {
    totalDebitAmount = 0;
    totalCreditAmount = 0;
    var mList = await db.getAllEntries();
    var mListAmounts = [];
    setState(() {
      creditList = mList.reversed.toList();
      for (int i = 0; i < mList.length; i++) {
        if (mList[i]['amount'] < 0) {
          mListAmounts.add(-1 * mList[i]['amount']);
          totalDebitAmount += mList[i]['amount'];
        } else {
          mListAmounts.add(mList[i]['amount']);
          totalCreditAmount += mList[i]['amount'];
        }
      }
      var _data = <CircularStackEntry>[
        CircularStackEntry(<CircularSegmentEntry>[
          CircularSegmentEntry(
              positiveAmount(totalDebitAmount) * 100 / (totalCreditAmount + positiveAmount(totalDebitAmount)),
              Colors.grey,
              rankKey: "Debit"),
          CircularSegmentEntry(
              totalCreditAmount * 100 / (totalCreditAmount + positiveAmount(totalDebitAmount)),
              Colors.pink,
              rankKey: "Credit"),
        ], rankKey: "Summary"),
      ];
      _chartKey.currentState.updateData(_data);
      allAmounts = mListAmounts.reversed.toList();
    });
  }
  double positiveAmount(double debitAmount) {
    return (debitAmount < 0) ? debitAmount * -1 : debitAmount;
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

  Future<Null> deleteEntry(int id) async {
    db.deleteEntry(id);
  }

  Future<Null> addEntry(Entry entry) async {
    db.saveEntry(entry);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllFromDB();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
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
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.pink,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddExpenditurePage()))
                  .then((context) {
                getAllFromDB();
              });
            },
            child: Icon(Icons.add)),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "ALL TRANSACTION HISTORY",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.0),
          ),
        ),
        body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Stack(alignment: Alignment.center, children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            AnimatedCircularChart(
                              key: _chartKey,
                              size: Size(150.0, 150.0),
                              initialChartData: data,
                              chartType: CircularChartType.Pie,
                              edgeStyle: SegmentEdgeStyle.round,
                              percentageValues: true,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(width: 12.0,height: 12.0,child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey)),),
                                      SizedBox(width: 8.0,),
                                      Text("Debit - \$" + positiveAmount(totalDebitAmount).toStringAsFixed(2)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(width: 12.0,height: 12.0,child: DecoratedBox(decoration: BoxDecoration(color: Colors.pink)),),
                                      SizedBox(width: 8.0,),
                                      Text("Credit - \$" + positiveAmount(totalCreditAmount).toStringAsFixed(2)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]),
                      (creditList.length == 0 || creditList.length == null)
                          ? Text(
                              "You have no transaction history",
                              style: TextStyle(color: Colors.white),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: creditList.length,
                              itemBuilder: (context, i) => Dismissible(
                                  direction: DismissDirection.endToStart,
                                  background: Card(
                                    color: Colors.red,
                                    child: Container(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 20.0),
                                    ),
                                  ),
                                  key: Key(creditList[i]['id'].toString()),
                                  onDismissed: (direction) {
                                    setState(() {
                                      db.deleteEntry(creditList[i]['id']);
                                      deletedList.insert(i, creditList[i]);
                                      creditList.removeAt(i);
                                      allAmounts.removeAt(i);
                                      getAllFromDB();
                                    });
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Transaction deleted"),
                                      action: SnackBarAction(
                                          label: "UNDO",
                                          onPressed: () {
                                            setState(() {
                                              var deletedItem = deletedList[i];
                                              creditList.insert(i, deletedItem);
                                              allAmounts.insert(
                                                  i,
                                                  (deletedItem['amount'] > 0)
                                                      ? deletedItem['amount']
                                                      : deletedItem['amount'] *
                                                          -1);
                                              addEntry(Entry(
                                                  deletedList[i]['title'],
                                                  deletedList[i]['description'],
                                                  deletedList[i]['amount'],
                                                  deletedList[i]['time']));
                                              getAllFromDB();
                                            });
                                          }),
                                    ));
                                  },
                                  child: Card(
                                    color: Color(0xff3d4255),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransactionInformationPage(
                                                        creditList[i]
                                                            ['id']))).then(
                                            (context) {
                                          getAllFromDB();
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    creditList[i]['title'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    (creditList[i]['amount'] >
                                                            0)
                                                        ? "Credit"
                                                        : "Debit",
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.white70),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    "\$" +
                                                        allAmounts[i]
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: Colors.white70),
                                                  ),
                                                  Text(
                                                    "${readTimestamp(creditList[i]['time'])}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white70),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
