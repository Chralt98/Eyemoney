import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/switch.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'add_category.dart';
import 'globals.dart';
import 'transaction.dart';

class Adding extends StatefulWidget {
  final DateTime selectedDate;

  const Adding({Key key, @required this.selectedDate}) : super(key: key);

  @override
  _AddingState createState() => new _AddingState();
}

class _AddingState extends State<Adding> {
  List<String> _categories = List<String>();
  SharedPreferences _prefs;
  String _description;
  String _amount = '0.00';
  String _selectedCategory;
  CrazySwitch _crazySwitch = new CrazySwitch();
  var moneyController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  int _radioVal = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._prefs = prefs);
        _loadCategoryPref();
      });
  }

  // TODO: use a sqflite database for saving the user data on device
  // only category for shared preferences
  void _loadCategoryPref() {
    setState(() {
      _categories =
          this._prefs.getStringList(categoryPrefKey) ?? standard_categories;
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first;
      }
    });
  }

  Future<Null> _setCategoryPref(List<String> categories) async {
    await this._prefs.setStringList(categoryPrefKey, categories);
    _loadCategoryPref();
  }

  @override
  Widget build(BuildContext context) {
    final _listTiles = _categories
        .map((item) => Container(
            decoration: new BoxDecoration(
                border: new Border(
                    top: BorderSide(color: Colors.black26, width: 2))),
            child: RadioListTile<int>(
                value: _categories.indexOf(item),
                groupValue: this._radioVal,
                onChanged: (int value) {
                  setState(() {
                    this._radioVal = value;
                    _selectedCategory = item;
                  });
                },
                activeColor: Colors.blue,
                title: Text(item))))
        .toList();
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Add'),
          actions: [],
        ),
        body: new Stack(alignment: AlignmentDirectional.topCenter, children: <
            Widget>[
          new SingleChildScrollView(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 40),
                TextField(
                  controller: moneyController,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.attach_money),
                    labelText: 'amount',
                  ),
                  onChanged: (String number) => this._amount = number,
                ),
                SizedBox(height: 26),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.info_outline),
                    hintText: 'What is it?',
                    labelText: 'description',
                  ),
                  onChanged: (String text) => this._description = text,
                  maxLength: 50,
                ),
                SizedBox(height: 26),
                Row(
                  children: <Widget>[
                    Text('expenditure',
                        style: TextStyle(color: Colors.red),
                        textScaleFactor: 1.1),
                    SizedBox(width: 16),
                    _crazySwitch,
                    SizedBox(width: 16),
                    Text('revenue',
                        style: TextStyle(color: Colors.lightGreen),
                        textScaleFactor: 1.1),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(height: 26),
                Column(
                  children: _listTiles,
                ),
                RaisedButton(
                    child: Icon(Icons.add),
                    onPressed: () async {
                      String category = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddCategory()));
                      if (category != null) {
                        this._categories.add(category);
                        this._setCategoryPref(this._categories);
                        this._loadCategoryPref();
                      }
                    }),
              ],
            ),
          ),
          Container(
            child: new FloatingActionButton(
              child: Icon(Icons.check),
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                final int sign = _crazySwitch.isChecked() ? 1 : -1;
                final double _realAmount = round(
                    (sign) *
                        10 *
                        double.parse(_amount.replaceAll(new RegExp(','), '')),
                    2);
                final MyTransaction data = MyTransaction(
                  category: _selectedCategory,
                  description: _description,
                  amount: _realAmount,
                  date: DateTime((widget.selectedDate ?? DateTime.now()).year,
                          (widget.selectedDate ?? DateTime.now()).month)
                      .toString(),
                );
                _insertInDatabase(data);
                try {
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              },
            ),
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.all(16),
          )
        ]));
  }

  double round(double val, double places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  void _insertInDatabase(MyTransaction data) async {
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

    Future<void> insertTransaction(MyTransaction transaction) async {
      // Get a reference to the database.
      final Database db = await database;

      // Insert the Dog into the correct table. Also specify the
      // `conflictAlgorithm`. In this case, if the same dog is inserted
      // multiple times, it replaces the previous data.
      await db.insert(
        'transactions',
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    void print_transactions() async {
      // Get a reference to the database.
      final Database db = await database;

      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await db.query('transactions');

      // id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, description TEXT, amount REAL, date DATE
      // Convert the List<Map<String, dynamic> into a List<Dog>.
      for (int i = 0; i < maps.length; i++) {
        print(MyTransaction(
            id: maps[i]['id'],
            category: maps[i]['category'],
            description: maps[i]['description'],
            amount: maps[i]['amount'],
            date: maps[i]['date']));
      }
    }

    // Insert a transaction into the database.
    await insertTransaction(data);

    // Print the list of transactions (only data for now).
    print_transactions();

    /*
    Future<void> updateTransaction(Transaction transaction) async {
      // Get a reference to the database.
      final db = await database;

      // Update the given Dog.
      await db.update(
        'transactions',
        transaction.toMap(),
        // Ensure that the Dog has a matching id.
        where: "amount = ?",
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [transaction.amount],
      );
    }

    Future<void> deleteTransaction(int id) async {
      // Get a reference to the database.
      final db = await database;

      // Remove the Dog from the database.
      await db.delete(
        'transactions',
        // Use a `where` clause to delete a specific dog.
        where: "id = ?",
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
    }

    // Update Fido's age and save it to the database.
    data = Transaction(
        category: data.category,
        description: data.description,
        amount: data.amount + 69.0,
        date: data.date);
    await updateTransaction(data);

    // Print Fido's updated information.
    print(await transactions());

    // Delete Fido from the database.
    await deleteTransaction(data.id);

    // Print the list of dogs (empty).
    print(await transactions());
     */
  }
}
