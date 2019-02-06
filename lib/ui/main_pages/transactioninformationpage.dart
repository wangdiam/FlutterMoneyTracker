import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/ui/main_pages/edittransactioninformationpage.dart';
import 'package:flutter_money_tracker/utils/database_helper.dart';
import 'package:intl/intl.dart';

class TransactionInformationPage extends StatefulWidget {
  int id;
  TransactionInformationPage(this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TransactionInformationPageState(this.id);
  }

}

class TransactionInformationPageState extends State<TransactionInformationPage>{
  int id;
  TransactionInformationPageState(this.id);
  var transactionData;
  var parsedAmount;
  var db = DatabaseHelper();

  Future<Null> getTransactionFromDb(int id) async {
    var data = await db.getTransactionById(id);
    setState(() {
      transactionData = data;
      if (data[0]['amount'] < 0) {
        parsedAmount = data[0]['amount'] * -1;
      } else {
       parsedAmount = data[0]['amount'];
      }
    });
  }

  Future<Null> deleteCurrentEntry(int id) async {
    db.deleteEntry(id);
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
    getTransactionFromDb(id);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        deleteCurrentEntry(id);
        Navigator.pop(context);
      },
      child: Icon(Icons.delete_forever),
      backgroundColor: Colors.red,),
      body: Stack(
        children: <Widget>[
          AppBar(
            centerTitle: true,
            title: Text("TRANSACTION",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12.0
              ),),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditTransactionInformationPage(id))).then((context){
                    getTransactionFromDb(id);
                  });
                },
              )
            ],
          ),
          Center(
            child: (transactionData == null) ? Text("Loading...") : Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.check_circle_outline,
                        color: ((transactionData[0]['amount']<0) ? Colors.red: Colors.greenAccent),
                        size: 70.0,)
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Total " + ((transactionData[0]['amount']<0) ? "Spent" : "Received"),
                      style: TextStyle(
                        color: Colors.white70
                      ),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("\$" + parsedAmount.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 36.0,
                              fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),),
                      ),
                    ],
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("CATEGORY",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12.0
                                      ),),
                                      Text("TIME",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12.0
                                        ),),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(transactionData[0]['title'],
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(readTimestamp(transactionData[0]['time']),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                        ),),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("DESCRIPTION",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12.0
                                        ),),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(transactionData[0]['description'],
                                          style: TextStyle(
                                              fontSize: 18.0,
                                          ),),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]
      ),
    );
  }
}