import 'package:Eyemoney/custom_widgets/dismissible_background.dart';
import 'package:Eyemoney/custom_widgets/home/btn_month_selection.dart';
import 'package:Eyemoney/custom_widgets/home/date_display.dart';
import 'package:Eyemoney/custom_widgets/home/drawer.dart';
import 'package:Eyemoney/custom_widgets/home/list_info.dart';
import 'package:Eyemoney/custom_widgets/home/list_tile.dart';
import 'package:Eyemoney/custom_widgets/home/money_sums.dart';
import 'package:Eyemoney/database/transaction.dart';
import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:Eyemoney/outsourcing/my_classes.dart';
import 'package:Eyemoney/outsourcing/my_functions.dart';
import 'package:Eyemoney/screens/adding.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class Home extends StatefulWidget {
  final String title;
  static const routeName = '/';

  const Home({Key key, @required this.title}) : super(key: key);

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _selectedDate;
  List<MyTransaction> _myTransactions;
  ScrollController _scrollController = new ScrollController();
  Set<int> _selectedItems = Set<int>();
  double _selectedItemsSum = 0;

  @override
  void initState() {
    super.initState();
    // DateTime.now(); => 2019-08-05 17:41:24.065004
    _selectedDate = DateTime.now();
    _loadDatabase();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).accentColor,
        actions: <Widget>[
          DateDisplay(date: _selectedDate),
          MonthSelector(onPressed: _showMonthPicker),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            MoneySums(
              transactions: _myTransactions,
            ),
            ListInfo(),
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
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          setState(() {
            _selectedItems.clear();
            _selectedItemsSum = 0;
          });
          // pass arguments
          Navigator.pushNamed(
            context,
            Adding.routeName,
            arguments: AddingArguments(selectedDate: _selectedDate, balance: _getBalance()),
          ).then((response) => _loadDatabase());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _getList(BuildContext context) {
    if (_myTransactions != null && _myTransactions.isNotEmpty) {
      return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 120),
        itemCount: _myTransactions.length,
        itemBuilder: (BuildContext context, int index) {
          final MyTransaction _item = _myTransactions[index];
          final String _description = _item.description;
          final double _amount = _item.sign * _item.amount * _item.quantity;
          final String _stringAmount = normTwoDecimal(round(_amount, 2).toString());
          final bool _isSelected = _selectedItems.contains(index);
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                Adding.routeName,
                arguments: AddingArguments(selectedDate: _selectedDate, balance: _getBalance(), myTransaction: _item),
              ).then((response) => _loadDatabase());
            },
            child: Dismissible(
              key: Key(_item.id.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (DismissDirection dir) {
                if (dir == DismissDirection.endToStart) {
                  setState(() {
                    _myTransactions.removeAt(index);
                    removeFromDatabase(_item);
                  });
                  _showScaffoldSnackBar(context, _description, _stringAmount, index, _item);
                }
              },
              background: DismissibleBackground(),
              child: MyListTile(
                description: _description,
                category: _item.category,
                amount: _amount,
                index: index,
                isSelected: _isSelected,
                onLongPress: () => _onLongPressListTile(index),
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

  void _onLongPressListTile(int index) {
    if (_selectedItems.contains(index)) {
      setState(() {
        _selectedItems.remove(index);
      });
    } else {
      setState(() {
        _selectedItems.add(index);
      });
    }
    _selectedItems.forEach((index) {
      MyTransaction _item = _myTransactions[index];
      _selectedItemsSum += _item.sign * _item.amount * _item.quantity;
    });
    print('SUM: $_selectedItemsSum, Selected: $_selectedItems');
    _selectedItemsSum = 0;
  }

  void _showScaffoldSnackBar(BuildContext context, String _description, String _stringAmount, int index, MyTransaction _item) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('"' + (_description ?? '–') + '", ' + AppLocalizations.of(context).money + ': ' + _stringAmount + ', ' + AppLocalizations.of(context).removed),
        action: SnackBarAction(
          label: AppLocalizations.of(context).undo,
          onPressed: () {
            setState(
              () {
                _myTransactions.insert(index, _item);
                insertInDatabase(_item);
              },
            );
          },
        ),
      ),
    );
  }

  double _getBalance() {
    double balance = 0;
    if (_myTransactions != null) {
      for (int i = 0; i < _myTransactions.length; i++) {
        balance += _myTransactions[i].sign * _myTransactions[i].amount * _myTransactions[i].quantity;
      }
    }
    balance = round(balance, 2);
    return balance;
  }

  void _showMonthPicker() {
    setState(() {
      _selectedItems.clear();
      _selectedItemsSum = 0;
    });
    showMonthPicker(context: context, initialDate: _selectedDate ?? DateTime.now()).then(
      (date) => setState(
        () {
          if ((date ?? DateTime.now()).month == DateTime.now().month) {
            _selectedDate = DateTime.now();
          } else {
            DateTime now = DateTime.now();
            _selectedDate = DateTime(date.year, date.month, now.day, now.hour, now.minute, now.second);
          }
          _loadDatabase();
        },
      ),
    );
  }

  void _loadDatabase() {
    getDatabase(_selectedDate).then((list) {
      setState(() {
        _myTransactions = list;
      });
    }).whenComplete(_scrollDown);
  }

  void _scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
