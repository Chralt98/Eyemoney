import 'dart:math';

import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'categories.dart';
import 'settings.dart';
import 'statistics.dart';

class Home extends StatefulWidget {
  final DateTime initialDate;
  final String title;

  const Home({Key key, @required this.title, @required this.initialDate})
      : super(key: key);

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  static var rand = new Random();
  List<String> items = List<String>.generate(
      20,
      (int counter) =>
          '$counter consumption ' + rand.nextInt(100).toString() + '€');
  List<String> infos = List<String>();
  // TODO: paint the font red for consumer spending and green for income
  List<double> values = List<double>();
  List<String> categories = List<String>();
  SharedPreferences _prefs;
  // TODO: find a place for global variables in all classes for no duplication
  static const String categoryPrefKey = 'category_pref';
  static const String infoPrefKey = 'info_pref';
  static const String valuePrefKey = 'value_pref';
  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._prefs = prefs);
        _loadCategoryPref();
        _loadValuePref();
        _loadInfoPref();
      });
  }

  // TODO: use a key value pair of category, value and info as keys
  void _loadCategoryPref() {
    setState(() {
      this._prefs.getList(categoryPrefKey) ?? 'electronics';
    });
  }

  void _loadValuePref() {
    setState(() {
      this._prefs.getList(valuePrefKey) ?? 0.0;
    });
  }

  void _loadInfoPref() {
    setState(() {
      this._prefs.getList(infoPrefKey) ?? 'cookies';
    });
  }

  Future<Null> _setValuePref(List<double> values) async {
    await this._prefs.setList(categoryPrefKey, values);
    _loadValuePref();
  }

  Future<Null> _setInfoPref(List<String> infos) async {
    await this._prefs.setList(infoPrefKey, infos);
    _loadInfoPref();
  }

  Future<Null> _setCategoryPref(List<String> categories) async {
    await this._prefs.setList(categoryPrefKey, categories);
    _loadCategoryPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.date_range),
              onPressed: () {
                showMonthPicker(
                        context: context,
                        initialDate: selectedDate ?? widget.initialDate)
                    .then((date) => setState(() {
                          selectedDate = date;
                          print(selectedDate.toString());
                        }));
              }),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(items[index]),
            );
          },
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
                  Text('Cashflow', textScaleFactor: 2),
                  Icon(
                    Icons.monetization_on,
                    size: 50,
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Statistics()));
              },
            ),
            ListTile(
              title: Text('Categories'),
              leading: Icon(Icons.category),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => new Categories()));
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Settings()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.attach_money),
        backgroundColor: Colors.blueAccent,
        onPressed: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
