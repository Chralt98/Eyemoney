import 'dart:async';

import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'adding.dart';
import 'categories.dart';
import 'globals.dart';
import 'settings.dart';
import 'statistics.dart';
import 'transaction.dart';

class Home extends StatefulWidget {
  final DateTime initialDate;
  final String title;

  const Home({Key key, @required this.title, @required this.initialDate}) : super(key: key);

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  // TODO: paint the font red for consumer spending and green for income
  DateTime _selectedDate;
  List<MyTransaction> _myTransactions;

  @override
  void initState() {
    super.initState();
    // DateTime.now(); => 2019-08-05 17:41:24.065004
    this._selectedDate = DateTime(DateTime.now().year, DateTime.now().month);
    this._loadDatabase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._loadDatabase();
  }

  void _loadDatabase() async {
    List<MyTransaction> temp = await _getDatabase();
    // refresh GUI
    setState(() {
      this._myTransactions = temp;
    });
  }

  List<double> _getTupleRevenueExpenditure() {
    double sumRevenue = 0.0;
    double sumExpenditure = 0.0;
    if (this._myTransactions != null) {
      for (int i = 0; i < this._myTransactions.length; i++) {
        if (this._myTransactions[i].amount > 0) {
          sumRevenue += this._myTransactions[i].amount;
        } else if (this._myTransactions[i].amount < 0) {
          sumExpenditure += this._myTransactions[i].amount;
        }
      }
    }
    return [round(sumRevenue, 2), round(sumExpenditure, 2)];
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          Container(
            child: Text((_selectedDate ?? DateTime.now()).month.toString() + ' / ' + (_selectedDate ?? DateTime.now()).year.toString()),
            alignment: Alignment.centerRight,
          ),
          IconButton(
              icon: Icon(Icons.date_range),
              onPressed: () {
                showMonthPicker(context: context, initialDate: _selectedDate ?? widget.initialDate).then((date) => setState(() {
                      _selectedDate = date;
                      this._loadDatabase();
                    }));
              }),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                      child: Text(_getTupleRevenueExpenditure()[0].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.lightGreen),
                          textScaleFactor: (_getTupleRevenueExpenditure()[0].toString().length < 12) ? 1.0 : 0.8),
                      width: screenWidth / 3,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black54))),
                  Container(
                      child: Text(_getTupleRevenueExpenditure()[1].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                          textScaleFactor: (_getTupleRevenueExpenditure()[1].toString().length < 12) ? 1.0 : 0.8),
                      width: screenWidth / 3,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black54))),
                  Container(
                      child: Text(round((_getTupleRevenueExpenditure()[0] + _getTupleRevenueExpenditure()[1]), 2).toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue),
                          textScaleFactor: (round((_getTupleRevenueExpenditure()[0] + _getTupleRevenueExpenditure()[1]), 2).toString().length < 12) ? 1.0 : 0.8),
                      width: screenWidth / 3,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black54))),
                ],
              ),
            ),
            Container(
              height: 27,
              color: Colors.black12,
              child: Row(
                children: <Widget>[
                  Container(child: Icon(Icons.info_outline), width: screenWidth / 3, decoration: BoxDecoration(border: Border.all(color: Colors.black54))),
                  Container(child: Icon(Icons.category), width: screenWidth / 3, decoration: BoxDecoration(border: Border.all(color: Colors.black54))),
                  Container(child: Icon(Icons.attach_money), width: screenWidth / 3, decoration: BoxDecoration(border: Border.all(color: Colors.black54))),
                ],
              ),
            ),
            Expanded(
                child: Container(
              child: _getList(context),
            )),
          ],
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(appName, textScaleFactor: 2, style: TextStyle(color: Colors.white)),
                  Icon(
                    Icons.monetization_on,
                    size: 50,
                    color: Colors.white,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Statistics'),
              leading: Icon(Icons.assessment),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Statistics()));
              },
            ),
            ListTile(
              title: Text('Categories'),
              leading: Icon(Icons.category),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Categories()));
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Settings()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.attach_money),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Adding(selectedDate: _selectedDate)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _getList(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    if (_myTransactions.isEmpty) {
      return Center(child: Icon(Icons.edit, size: 60, color: Colors.black38));
    }
    if (_myTransactions != null) {
      return ListView.builder(
          padding: EdgeInsets.only(bottom: 90),
          itemCount: _myTransactions.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.only(bottom: 10, top: 10),
              decoration: BoxDecoration(
                  color: (index % 2 == 0) ? Color.fromARGB(5, 255, 255, 0) : Color.fromARGB(5, 0, 0, 255),
                  border: Border.fromBorderSide(BorderSide(width: 0.0, color: Colors.black12, style: BorderStyle.solid))),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Text(_myTransactions[index].description ?? '–', textScaleFactor: 1.2, textAlign: TextAlign.center),
                    width: screenWidth / 3,
                  ),
                  Container(
                    child: Text(_myTransactions[index].category ?? '–', textScaleFactor: 1.2, textAlign: TextAlign.center),
                    width: screenWidth / 3,
                  ),
                  Container(
                      child: Text(_myTransactions[index].amount.toString() ?? '–',
                          textScaleFactor: ((_myTransactions[index].amount.toString() ?? '–').length < 12) ? 1.0 : 0.9,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: (_myTransactions[index].amount < 0.0) ? Colors.red : Colors.lightGreen)),
                      width: screenWidth / 3),
                ],
              ),
            );
          });
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Future<List<MyTransaction>> _getDatabase() async {
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), appName + 'Database.db'),
      // When the database is first created, create a table to store transactions.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, description TEXT, amount REAL, date DATETIME)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query('transactions', where: "date = ?", whereArgs: [(_selectedDate ?? DateTime(DateTime.now().year, DateTime.now().month)).toString()]);

    return List.generate(maps.length, (i) {
      return MyTransaction(
        id: maps[i]['id'],
        category: maps[i]['category'],
        description: maps[i]['description'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
      );
    });
  }
}
