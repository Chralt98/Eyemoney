import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/switch.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';

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
  var moneyController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
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
      _categories = this._prefs.getStringList(categoryPrefKey) ?? standard_categories;
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _listTiles = _categories
        .map((item) => RadioListTile<int>(
            value: _categories.indexOf(item),
            groupValue: this._radioVal,
            onChanged: (int value) {
              setState(() {
                this._radioVal = value;
                _selectedCategory = item;
              });
            },
            activeColor: Colors.blue,
            title: Text(item)))
        .toList();
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Add'),
          actions: [],
        ),
        body: new Stack(alignment: AlignmentDirectional.topCenter, children: <Widget>[
          new SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 40),
                TextFormField(
                  controller: moneyController,
                  keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.attach_money),
                    hintText: 'How much is it?',
                    labelText: 'amount',
                  ),
                  onFieldSubmitted: (String number) => this._amount = number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'value is required.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 26),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.info_outline),
                    hintText: 'What is it?',
                    labelText: 'description',
                  ),
                  onFieldSubmitted: (String text) => this._description = text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'description is required.';
                    }
                    return null;
                  },
                  maxLength: 50,
                ),
                SizedBox(height: 26),
                Row(
                  children: <Widget>[
                    Text('expenditure', style: TextStyle(color: Colors.red), textScaleFactor: 1.1),
                    _crazySwitch,
                    Text('revenue', style: TextStyle(color: Colors.lightGreen), textScaleFactor: 1.1),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
                SizedBox(height: 26),
                Column(
                  children: _listTiles,
                ),
              ],
            ),
          ),
          Container(
            child: new FloatingActionButton(
              child: Icon(Icons.check),
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                print(_selectedCategory);
                print(_description);
                print(_amount);
                print(_crazySwitch.isChecked());
                print(widget.selectedDate.month.toString() + '/' + widget.selectedDate.year.toString());
                // TODO: _insertInDatabase();
              },
            ),
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.all(16),
          )
        ]));
  }
}

class Transaction {
  final String category;
  final String description;
  final String amount;
  final bool revenue;
  final String month;
  final String year;

  Transaction({this.category, this.description, this.amount, this.revenue, this.month, this.year});
}
