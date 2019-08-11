import 'package:Eyemoney/database/transaction.dart';
import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:Eyemoney/screens/adding.dart';
import 'package:Eyemoney/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../outsourcing/globals.dart';
import '../outsourcing/my_functions.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  final DateTime initialDate;
  final String title;

  const Home({Key key, @required this.title, @required this.initialDate}) : super(key: key);

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
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

  @override
  Widget build(BuildContext context) {
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
              showMonthPicker(context: context, initialDate: _selectedDate ?? widget.initialDate).then(
                (date) => setState(
                  () {
                    _selectedDate = date;
                    this._loadDatabase();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  this._getSum(context, _getTupleRevenueExpenditure()[0], Colors.lightGreen),
                  this._getSum(context, _getTupleRevenueExpenditure()[1], Colors.red),
                  this._getSum(context, _getTupleRevenueExpenditure()[0] + _getTupleRevenueExpenditure()[1], Color.fromARGB(255, 0, 0, 50)),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  this._getLabel(AppLocalizations.of(context).description),
                  this._getLabel(AppLocalizations.of(context).category),
                  this._getLabel(AppLocalizations.of(context).amount),
                ],
              ),
            ),
            Container(
              height: 27,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  this._getSymbol(context, Icons.info_outline),
                  this._getSymbol(context, Icons.category),
                  this._getSymbol(context, Icons.fiber_smart_record),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: _getList(context),
              ),
            ),
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
                    Icons.fiber_smart_record,
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
              title: Text(AppLocalizations.of(context).home),
              leading: Icon(Icons.home),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).statistics),
              leading: Icon(Icons.assessment),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => Statistics()),
                );
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).settings),
              leading: Icon(Icons.settings),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => Settings()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Adding(selectedDate: _selectedDate),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _getList(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    if (_myTransactions != null && _myTransactions.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 120),
        itemCount: _myTransactions.length,
        itemBuilder: (BuildContext context, int index) {
          final MyTransaction item = _myTransactions[index];
          final String description = item.description;
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Adding(selectedDate: _selectedDate, myTransaction: item)));
            },
            child: Dismissible(
              key: Key(item.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (DismissDirection dir) {
                if (dir == DismissDirection.endToStart) {
                  setState(() {
                    this._myTransactions.removeAt(index);
                    removeFromDatabase(item);
                  });
                  final String desc = description ?? '–';
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"' + desc + '"' + ' ' + AppLocalizations.of(context).removed),
                      action: SnackBarAction(
                        label: AppLocalizations.of(context).undo,
                        onPressed: () {
                          setState(
                            () {
                              this._myTransactions.insert(index, item);
                              insertInDatabase(item);
                            },
                          );
                        },
                      ),
                    ),
                  );
                }
              },
              background: Container(
                color: Colors.red,
                child: Icon(Icons.delete),
                alignment: Alignment.centerRight,
              ),
              child: Container(
                padding: EdgeInsets.only(bottom: 5, top: 5),
                decoration: BoxDecoration(
                    color: (index % 2 == 0) ? Color.fromARGB(5, 255, 255, 0) : Color.fromARGB(5, 0, 0, 255),
                    border: Border.fromBorderSide(BorderSide(width: 0.0, color: Colors.black12, style: BorderStyle.solid))),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text(item.description ?? '–', textAlign: TextAlign.center),
                      width: screenWidth / 3,
                    ),
                    Container(
                      child: Text(item.category ?? AppLocalizations.of(context).other, textAlign: TextAlign.center),
                      width: screenWidth / 3,
                    ),
                    Container(
                        height: 38,
                        child: FittedBox(
                          child: Text(
                            normTwoDecimal(round((item.amount ?? 0.0), 2).toString()),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: (item.amount < 0.0) ? Colors.red : Colors.lightGreen),
                          ),
                          fit: BoxFit.scaleDown,
                        ),
                        width: screenWidth / 3),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (_myTransactions == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_myTransactions.isEmpty) {
      return Center(child: Icon(Icons.edit, size: 60, color: Colors.black12));
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void _loadDatabase() async {
    List<MyTransaction> temp = await getDatabase(_selectedDate);
    // refresh GUI
    setState(
      () {
        this._myTransactions = temp;
      },
    );
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

  Widget _getSum(BuildContext context, double amount, Color color) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final stringAmount = normTwoDecimal(round(amount, 2).toString());
    return Container(
      height: 26,
      width: screenWidth / 3,
      child: FittedBox(
        child: Text(stringAmount, textAlign: TextAlign.center, style: TextStyle(color: color)),
        fit: BoxFit.scaleDown,
      ),
    );
  }

  Widget _getLabel(String label) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      child: FittedBox(
        child: Text(
          label,
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 50)),
        ),
        fit: BoxFit.scaleDown,
      ),
      width: screenWidth / 3,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
      ),
    );
  }

  Widget _getSymbol(BuildContext context, IconData symbol) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Icon(symbol),
      width: screenWidth / 3,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
      ),
    );
  }
}