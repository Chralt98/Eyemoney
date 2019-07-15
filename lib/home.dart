import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/switch.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'categories.dart';
import 'globals.dart';
import 'overlay.dart';
import 'settings.dart';
import 'statistics.dart';

class Home extends StatefulWidget {
  final DateTime initialDate;
  final String title;

  const Home({Key key, @required this.title, @required this.initialDate}) : super(key: key);

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  static var rand = new Random();
  List<String> items = List<String>.generate(20, (int counter) => '$counter consumption ' + rand.nextInt(100).toString() + '€');

  // TODO: paint the font red for consumer spending and green for income
  List<String> categories = List<String>();
  SharedPreferences _prefs;
  DateTime selectedDate;
  String description;
  String amount;
  String _selectedCategory;

  @override
  void initState() {
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
      categories = this._prefs.getStringList(categoryPrefKey) ?? standard_categories;
    });
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
                showMonthPicker(context: context, initialDate: selectedDate ?? widget.initialDate).then((date) => setState(() {
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
          _showPopup(context, _popupBody(), 'Add');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  _showPopup(BuildContext context, Widget widget, String title, {BuildContext popupContext}) {
    Navigator.push(
      context,
      MyOverlay(
        top: 50,
        left: 50,
        right: 50,
        bottom: 50,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    try {
                      Navigator.pop(context); //close the popup
                    } catch (e) {
                      print(e);
                    }
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  Widget _popupBody() {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 24.0),
            TextFormField(
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(Icons.info_outline),
                hintText: 'e.g. water',
                labelText: 'description',
              ),
              onSaved: (String text) => this.description = text,
            ),
            SizedBox(height: 24.0),
            TextFormField(
              controller: MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.'),
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
              decoration: const InputDecoration(border: UnderlineInputBorder(), filled: true, icon: Icon(Icons.attach_money), hintText: 'e.g. 42', labelText: 'amount'),
              onSaved: (String number) => this.amount = number,
            ),
            SizedBox(height: 12.0),
            Row(
              children: <Widget>[
                Text('expenditure', style: TextStyle(color: Colors.red)),
                CrazySwitch(),
                Text('revenue', style: TextStyle(color: Colors.lightGreen)),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.category, color: Colors.black38),
                SizedBox(width: 16),
                Container(
                    child: DropdownButton(
                  value: _selectedCategory,
                  hint: Text('category'),
                  onChanged: ((String c) {
                    setState(() {
                      _selectedCategory = c;
                    });
                  }),
                  items: categories.map((String choice) => DropdownMenuItem<String>(value: choice, child: Text(choice))).toList(),
                )),
              ],
            ),
            SizedBox(height: 12.0),
            Container(
              child: FloatingActionButton(
                child: Icon(Icons.check),
                backgroundColor: Colors.blueAccent,
                onPressed: null,
              ),
              alignment: Alignment.bottomRight,
            ),
          ],
        ));
  }
}
