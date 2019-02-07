import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/model/entry.dart';
import 'package:flutter_money_tracker/utils/database_helper.dart';

class EditTransactionInformationPage extends StatefulWidget {

  var id;

  EditTransactionInformationPage(this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditTransactionInformationPageState(this.id);
  }

}

class EditTransactionInformationPageState extends State<EditTransactionInformationPage> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  var db = DatabaseHelper();
  int _radioValue = 0;
  int debitOrCredit = 0;
  var id;
  var transactionData;
  var parsedAmount;

  EditTransactionInformationPageState(this.id);

  Future<Null> retrieveEntryFromDB(int id) async {
    var data = await db.getTransactionById(id);
    setState(() {
      transactionData = data;
      if (data[0]['amount'] < 0) {
        parsedAmount = data[0]['amount'] * -1;
        setState(() {
          _radioValue = 0;
          debitOrCredit = 0;
        });

      } else {
        parsedAmount = data[0]['amount'];
        setState(() {
          _radioValue = 1;
          debitOrCredit = 1;
        });
      }
      titleController.text = data[0]['title'];
      descriptionController.text = data[0]['description'];
      amountController.text = parsedAmount.toString();
    });
  }

  Future<Null> updateEntryInDB(Entry entry) async {
    await db.updateEntryWithID(id,entry);
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          debitOrCredit = 0;
          break;
        case 1:
          debitOrCredit = 1;
          break;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveEntryFromDB(id);
  }

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("EDIT ENTRY",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12.0
              ),),
          ),
          floatingActionButton: FloatingActionButton(onPressed: () {
            double amount = double.tryParse(amountController.text);
            if (titleController.text.toString().length != 0 && descriptionController.text.toString().length != 0 && amountController.text.toString().length != 0) {
              if (debitOrCredit == 0) {
                amount = amount*-1;
              }
              Entry entry = Entry(titleController.text,descriptionController.text,amount,DateTime.now().millisecondsSinceEpoch);
              updateEntryInDB(entry);
              titleController.clear();
              descriptionController.clear();
              amountController.clear();
              Navigator.pop(context);
            }
          },
            child: Icon(Icons.save),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.category),
                      title: TextField(
                        controller: titleController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: "Category",
                        ),
                      )
                  ),
                  ListTile(
                      leading: Icon(Icons.description),
                      title: TextField(
                        controller: descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                      )
                  ),
                  ListTile(
                      leading: Icon(Icons.attach_money),
                      title: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true
                        ),
                        decoration: InputDecoration(
                          labelText: "Amount",
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text(
                          'Debit',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text(
                          'Credit',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          )
      );
    }
  }
