import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/model/entry.dart';
import 'package:flutter_money_tracker/utils/database_helper.dart';

class AddExpenditurePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddExpenditurePageState();
  }

}

class AddExpenditurePageState extends State<AddExpenditurePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  var db = DatabaseHelper();
  int _radioValue = 0;
  int debitOrCredit = 0;

  Future<Null> saveEntryToDB(Entry entry) async {
    await db.saveEntry(entry);
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
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ADD ENTRY",
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0
          ),),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
        double amount = double.tryParse(amountController.text);
        if (titleController.text.toString().length != 0 && descriptionController.text.toString().length != 0 && amountController.text.toString().length != 0) {
          if (debitOrCredit == 0) {
            amount = amount*-1;
          }
          Entry entry = Entry(titleController.text,descriptionController.text,amount,DateTime.now().millisecondsSinceEpoch);
          saveEntryToDB(entry);
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