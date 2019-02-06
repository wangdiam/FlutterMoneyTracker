import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/ui/main_pages/transactioninformationpage.dart';
import 'package:flutter_money_tracker/utils/database_helper.dart';
import 'package:intl/intl.dart';

class AllTransactionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AllTransactionsPageState();
  }

}

class AllTransactionsPageState extends State<AllTransactionsPage>{

  int moneyLeft = 0;
  var debitList = [];
  var creditList = [];
  List<dynamic> allAmounts = [];
  var db = DatabaseHelper();

  Future<Null> getAllFromDB() async {
    var mList = await db.getAllEntries();
    var mListAmounts = [];
    setState(() {
      creditList = mList.reversed.toList();
      debitList = mList.reversed.toList();
      for (int i = 0; i < mList.length; i++) {
        if (mList[i]['amount']<0) {
          mListAmounts.add(-1 * mList[i]['amount']);
        } else {
          mListAmounts.add(mList[i]['amount']);
        }
      }
      allAmounts = mListAmounts.reversed.toList();
    }
    );
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
    getAllFromDB();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ALL TRANSACTION HISTORY",
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0
          ),),
      ),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: (creditList.length == 0 || creditList.length == null) ?
            Text("You have no transaction history",
            style: TextStyle(
              color: Colors.white
            ),)
                : ListView.builder(
                itemCount: creditList.length,
                itemBuilder: (context,i) => Card(
                  color: Colors.indigo[400],
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => TransactionInformationPage(debitList[i]['id'])))
                            .then((context){
                          getAllFromDB();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(creditList[i]['title'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      color: Colors.white
                                    ),),
                                  Text((creditList[i]['amount'] > 0) ? "Credit" : "Debit",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                      color: Colors.white70
                                  ),)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("\$" + allAmounts[i].toStringAsFixed(2),
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
      ),
    );
  }
}