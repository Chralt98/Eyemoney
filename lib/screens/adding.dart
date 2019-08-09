import 'dart:async';

import 'package:Eyemoney/custom_widgets/switch.dart';
import 'package:Eyemoney/database/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../outsourcing/globals.dart';
import '../outsourcing/my_functions.dart';
import 'add_category.dart';

class Adding extends StatefulWidget {
  final DateTime selectedDate;
  final MyTransaction myTransaction;

  const Adding({Key key, @required this.selectedDate, this.myTransaction})
      : super(key: key);

  @override
  _AddingState createState() => new _AddingState();
}

class _AddingState extends State<Adding> {
  List<String> _categories = List<String>();
  SharedPreferences _prefs;
  String _description;
  String _amount = '0.00';
  String _selectedCategory;
  CrazySwitch _crazySwitch;
  var _moneyController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  int _radioVal = 0;
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._scrollController = new ScrollController();
    this._descriptionController = new TextEditingController();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._prefs = prefs);
        this._loadCategoryPref();
        if (widget.myTransaction != null) {
          double temp = ((widget.myTransaction.amount < 0
              ? widget.myTransaction.amount * -1
              : widget.myTransaction.amount));
          this._amount = temp.toString() ?? '0.00';
          _moneyController.updateValue(temp);
          this._crazySwitch = new CrazySwitch(
              isChecked: widget.myTransaction.amount >= 0 ? true : false);
          this._description = widget.myTransaction.description;
          this._descriptionController.text = this._description;
          this._selectedCategory = widget.myTransaction.category;
          this._radioVal = _categories.indexOf(this._selectedCategory);
        } else {
          this._crazySwitch = new CrazySwitch(isChecked: false);
        }
      });
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    this._moneyController.dispose();
    this._descriptionController.dispose();
    super.dispose();
  }

  // TODO: use a sqflite database for saving the user data on device
  // only category for shared preferences
  void _loadCategoryPref() {
    setState(() {
      _categories =
          this._prefs.getStringList(categoryPrefKey) ?? standard_categories;
      if (_categories.isEmpty) {
        _categories.insert(0, '–');
      } else if (_categories.isNotEmpty && _categories.first != '–') {
        _categories.insert(0, '–');
      }
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
            decoration: BoxDecoration(
                color: (_categories.indexOf(item) % 2 == 0)
                    ? Color.fromARGB(5, 255, 255, 0)
                    : Color.fromARGB(5, 0, 0, 255),
                border: Border.fromBorderSide(BorderSide(
                    width: 0.0,
                    color: Colors.black12,
                    style: BorderStyle.solid))),
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
                title: Container(
                    child: Text(item,
                        textScaleFactor:
                            (item.toString().length > 18) ? 0.65 : 1.0)))))
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
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40),
                  TextFormField(
                    controller: _moneyController,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.attach_money),
                      labelText: 'amount *',
                    ),
                    validator: (String number) {
                      if (number == '0.00') {
                        _scrollController.animateTo(0,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.ease);
                        return 'Please enter an amount!';
                      }
                      return null;
                    },
                    onFieldSubmitted: (String number) => this._amount = number,
                    // onChanged: (String number) => this._amount = number,
                  ),
                  SizedBox(height: 26),
                  TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.info_outline),
                      hintText: 'What is it?',
                      labelText: 'description (optional)',
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
                      this._crazySwitch ?? CrazySwitch(isChecked: false),
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
                          this._radioVal = this._categories.indexOf(category);
                          await this._setCategoryPref(this._categories);
                          this._selectedCategory = _categories.last;
                        }
                      }),
                ],
              ),
            ),
            controller: _scrollController,
          ),
          Container(
            child: new FloatingActionButton(
              child: Icon(Icons.check),
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  this._amount = _moneyController.numberValue.toString();
                  final int sign = _crazySwitch.getChecked() ? 1 : -1;
                  final double _realAmount = round(
                      (sign) *
                          double.parse(_amount.replaceAll(new RegExp(','), '')),
                      2);
                  if (widget.myTransaction != null) {
                    final MyTransaction data = MyTransaction(
                      id: widget.myTransaction.id,
                      category: _selectedCategory,
                      description: _description,
                      amount: _realAmount,
                      date: DateTime(
                              (widget.selectedDate ?? DateTime.now()).year,
                              (widget.selectedDate ?? DateTime.now()).month)
                          .toString(),
                    );
                    this._updateTransaction(data);
                  } else {
                    final MyTransaction data = MyTransaction(
                      category: _selectedCategory,
                      description: _description,
                      amount: _realAmount,
                      date: DateTime(
                              (widget.selectedDate ?? DateTime.now()).year,
                              (widget.selectedDate ?? DateTime.now()).month)
                          .toString(),
                    );
                    this._insertInDatabase(data);
                  }
                  try {
                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                  }
                }
              },
            ),
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.all(16),
          )
        ]));
  }

  Future<void> _updateTransaction(MyTransaction transaction) async {
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
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'transactions',
      transaction.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [transaction.id],
    );
  }

  Future<void> _insertInDatabase(MyTransaction data) async {
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

    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'transactions',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
