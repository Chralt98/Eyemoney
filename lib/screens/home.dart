import 'package:Eyemoney/custom_widgets/dismissible_background.dart';
import 'package:Eyemoney/custom_widgets/home/btn_month_selection.dart';
import 'package:Eyemoney/custom_widgets/home/date_display.dart';
import 'package:Eyemoney/custom_widgets/home/drawer.dart';
import 'package:Eyemoney/custom_widgets/home/list_info_icon.dart';
import 'package:Eyemoney/custom_widgets/home/list_info_label.dart';
import 'package:Eyemoney/custom_widgets/home/list_tile.dart';
import 'package:Eyemoney/custom_widgets/home/money_sums.dart';
import 'package:Eyemoney/database/transaction.dart';
import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:Eyemoney/screens/adding.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({Key key, @required this.title}) : super(key: key);

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          DateDisplay(date: this._selectedDate),
          MonthSelector(onPressed: _showMonthPicker),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            MoneySums(transactions: this._myTransactions),
            ListInfoLabel(),
            ListInfoIcon(),
            Expanded(
              child: Container(
                child: _getList(context),
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Adding(selectedDate: _selectedDate),
            ),
          ).then((response) => this._loadDatabase());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _getList(BuildContext context) {
    if (_myTransactions != null && _myTransactions.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 120),
        itemCount: _myTransactions.length,
        itemBuilder: (BuildContext context, int index) {
          final MyTransaction item = _myTransactions[index];
          final String description = item.description;
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Adding(selectedDate: _selectedDate, myTransaction: item)))
                  .then((response) => this._loadDatabase());
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
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"' + (description ?? '–') + '"' + ' ' + AppLocalizations.of(context).removed),
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
              background: DismissibleBackground(),
              child: MyListTile(
                description: item.description,
                category: item.category,
                amount: item.amount,
                index: index,
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

  void _showMonthPicker() {
    showMonthPicker(context: context, initialDate: _selectedDate ?? DateTime(DateTime.now().year, DateTime.now().month)).then(
      (date) => setState(
        () {
          _selectedDate = date;
          this._loadDatabase();
        },
      ),
    );
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
}
