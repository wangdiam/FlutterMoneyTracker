import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/ui/main_pages/transactioninformationpage.dart';
import 'package:flutter_money_tracker/utils/database_helper.dart';
import 'package:intl/intl.dart';

class AllDebitPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AllDebitPageState();
  }

}

class AllDebitPageState extends State<AllDebitPage>{

  int moneyLeft = 0;
  var debitList = [];
  var creditList = [];
  var debitListAmounts = [];
  var db = DatabaseHelper();

  Future<Null> getAllDebitHistoryFromDB() async {
    var mList = await db.getAllDebit();
    var mListAmounts = [];
    setState(() {
      print(mList.length);
      debitList = mList.reversed.toList();
      for (int i=0;i<mList.length;i++) {
        mListAmounts.add(-1*mList[i]['amount']);
        print(mList[i]['amount']);
      }
      debitListAmounts = mListAmounts.reversed.toList();
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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("DEBIT HISTORY",
          style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12.0
          ),),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff42475d),
              Color(0xff3d4256),
              Color(0xff363b4f),
              Color(0xff2d3142),
            ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1,0.5,0.7,0.9])
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: (debitList.length == 0 || debitList.length == null) ?
            Text("You have no debit history",
                style: TextStyle(
                    color: Colors.white
                ))
                : ListView.builder(
                itemCount: debitList.length,
                itemBuilder: (context,i) => Card(
                  color: Color(0xff3d4255),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => TransactionInformationPage(debitList[i]['id'])))
                            .then((context){
                          getAllDebitHistoryFromDB();
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
                )),
          ),
        ),
      ),
    );
  }
}