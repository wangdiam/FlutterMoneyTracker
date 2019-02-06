import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/ui/main_pages/transactioninformationpage.dart';
import 'package:flutter_money_tracker/utils/database_helper.dart';
import 'package:intl/intl.dart';

class AllCreditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AllCreditPageState();
  }

}

class AllCreditPageState extends State<AllCreditPage>{

  int moneyLeft = 0;
  var debitList = [];
  var creditList = [];
  var debitListAmounts = [];
  var db = DatabaseHelper();

  Future<Null> getAllCreditHistoryFromDB() async {
    var mList = await db.getAllCredit();
    setState(() {
      creditList = mList.reversed.toList();
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
    getAllCreditHistoryFromDB();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("CREDIT HISTORY",
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (creditList.length == 0 || creditList.length == null) ?
              Text("You have no credit history",
                  style: TextStyle(
                      color: Colors.white
                  ))
                  : ListView.builder(
                  itemCount: creditList.length,
                  itemBuilder: (context,i) => Card(
                      color: Colors.indigo[400],
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => TransactionInformationPage(creditList[i]['id'])))
                              .then((context){
                            getAllCreditHistoryFromDB();
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
                                    Text("\$" + creditList[i]['amount'].toString(),
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