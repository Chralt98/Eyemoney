import 'package:flutter/material.dart';
import 'dart:math';
import 'statistics.dart';
import 'categories.dart';
import 'settings.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

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
  DateTime selectedDate;

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
              child: Text('Cashflow'),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Statistics'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Statistics()));
              },
            ),
            ListTile(
              title: Text('Categories'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Categories()));
              },
            ),
            ListTile(
              title: Text('Settings'),
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
        onPressed: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
