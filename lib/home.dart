import 'dart:math';

import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adding.dart';
import 'categories.dart';
import 'globals.dart';
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

  // TODO: paint the font red for consumer spending and green for income
  List<String> categories = List<String>();
  SharedPreferences _prefs;
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    this._selectedDate = DateTime.now();
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
      categories =
          this._prefs.getStringList(categoryPrefKey) ?? standard_categories;
    });
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
            child: Text((_selectedDate ?? DateTime.now()).month.toString() +
                ' / ' +
                (_selectedDate ?? DateTime.now()).year.toString()),
            alignment: Alignment.centerRight,
          ),
          IconButton(
              icon: Icon(Icons.date_range),
              onPressed: () {
                showMonthPicker(
                        context: context,
                        initialDate: _selectedDate ?? widget.initialDate)
                    .then((date) => setState(() {
                          _selectedDate = date;
                        }));
              }),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 27,
              color: Colors.black12,
              child: Row(
                children: <Widget>[
                  Container(
                      child: Icon(Icons.info_outline),
                      width: screenWidth / 3,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54))),
                  Container(
                      child: Icon(Icons.category),
                      width: screenWidth / 3,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54))),
                  Container(
                      child: Icon(Icons.attach_money),
                      width: screenWidth / 3,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54))),
                ],
              ),
            ),
            Expanded(
                child: Container(
              child: ListView.builder(
                  itemCount: 100,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(BorderSide(
                                width: 0.0,
                                color: Colors.black12,
                                style: BorderStyle.solid))),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text('info',
                                  textScaleFactor: 1.2,
                                  textAlign: TextAlign.center),
                              width: screenWidth / 3,
                            ),
                            Container(
                              child: Text('category',
                                  textScaleFactor: 1.2,
                                  textAlign: TextAlign.center),
                              width: screenWidth / 3,
                            ),
                            Container(
                                child: Text('amount',
                                    textScaleFactor: 1.2,
                                    textAlign: TextAlign.center),
                                width: screenWidth / 3),
                          ],
                        ));
                  }),
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
                  Text('Cashprotocol',
                      textScaleFactor: 2,
                      style: TextStyle(color: Colors.white)),
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
                        builder: (BuildContext context) => Categories()));
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
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Adding(selectedDate: _selectedDate)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
