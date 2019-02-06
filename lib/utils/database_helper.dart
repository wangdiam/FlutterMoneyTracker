import 'dart:io';
import 'dart:async';
import 'package:flutter_money_tracker/model/entry.dart';
import 'package:flutter_money_tracker/model/weeklyamount.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory  = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,"moneytrackerflutter.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute("create table weeklyamounttable(id INTEGER PRIMARY KEY, amount REAL)");
    await db.execute("create table historytable(id integer primary key, title text, description text, amount REAL, time integer)");
  }

  Future<int> saveEntry(Entry entry) async {
    var dbClient = await db;
    int result = await dbClient.insert("historytable",entry.toMap());
    return result;
  }

  Future<int> saveWeeklyAmount(WeeklyAmount amount) async {
    var dbClient = await db;
    int result = await dbClient.insert("weeklyamounttable", amount.toMap());
    return result;
  }

  Future<List> getTransactionById(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM historytable WHERE id = " + id.toString());
    return result;
  }

  Future<List> getAllEntries() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM historytable");
    return result.toList();
  }
  
  Future<List> getAllDebit() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM historytable WHERE amount < 0");
    return result.toList();
  }

  Future<List> getAllCredit() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM historytable WHERE amount > 0");
    return result.toList();
  }

  Future<List> getWeeklyLimit() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * from weeklyamounttable order by id desc limit 1");
    return result;
  }

  Future<Null> deleteEntry(int id) async {
    var dbClient = await db;
    await dbClient.rawDelete("DELETE FROM historytable WHERE id = '$id'");
  }

  Future<Null> updateEntryWithID(int id,Entry entry) async {
    var dbClient = await db;
    await dbClient.update("historytable", entry.toMap(),where: "id = '$id'");
  }

}