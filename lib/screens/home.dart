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
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  DateTime _selectedDate;
  List<MyTransaction> _myTransactions;
  ScrollController _scrollController = new ScrollController();
  Set<int> _selectedItems = Set<int>();
  bool _isCheckBoxVisible = false;

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

  _handleDrawer() {
    _key.currentState.openDrawer();
    _clearSelected();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).accentColor,
        actions: <Widget>[
          DateDisplay(date: _selectedDate),
          MonthSelector(onPressed: _showMonthPicker),
        ],
        leading: new IconButton(
          icon: new Icon(Icons.menu),
          onPressed: _handleDrawer,
        ),
      ),
      body: Stack(alignment: Alignment.bottomRight, children: <Widget>[
        Container(
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
        Visibility(
          visible: _isCheckBoxVisible,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(5.0),
                  color: Colors.indigoAccent,
                ),
                margin: EdgeInsets.only(
                  left: 20,
                ),
                padding: EdgeInsets.all(5),
                child: Text(
                  AppLocalizations.of(context).money + ': ' + _getSelectedItemsSum(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.only(bottom: 16, end: 16),
                child: FloatingActionButton(
                  onPressed: _clearSelected,
                  child: Icon(Icons.clear),
                ),
              ),
            ],
          ),
        ),
      ]),
      drawer: MyDrawer(),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).accentColor,
          onPressed: () {
            _clearSelected();
            // pass arguments
            Navigator.pushNamed(
              context,
              Adding.routeName,
              arguments: AddingArguments(selectedDate: _selectedDate, balance: _getBalance()),
            ).then((response) => _loadDatabase());
          },
        ),
        visible: !_isCheckBoxVisible,
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
              if (_isCheckBoxVisible) {
                _checkBox(index);
              } else {
                Navigator.pushNamed(
                  context,
                  Adding.routeName,
                  arguments: AddingArguments(selectedDate: _selectedDate, balance: _getBalance(), myTransaction: _item),
                ).then((response) => _loadDatabase());
              }
            },
            onLongPress: () {
              setState(() {
                _selectedItems.clear();
                _isCheckBoxVisible = !_isCheckBoxVisible;
              });
            },
            child: Dismissible(
              key: Key(_item.id.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (DismissDirection dir) {
                if (dir == DismissDirection.endToStart) {
                  _clearSelected();
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
                isVisible: _isCheckBoxVisible,
                onChanged: (bool value) {
                  setState(() {
                    _checkBox(index);
                  });
                },
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

  void _clearSelected() {
    setState(() {
      _selectedItems.clear();
      _isCheckBoxVisible = false;
    });
  }

  void _checkBox(int index) {
    if (_selectedItems.contains(index)) {
      setState(() {
        _selectedItems.remove(index);
      });
    } else {
      setState(() {
        _selectedItems.add(index);
      });
    }
  }

  String _getSelectedItemsSum() {
    double _selectedItemsSum = 0;
    _selectedItems.forEach((index) {
      MyTransaction _item = _myTransactions[index];
      _selectedItemsSum += _item.sign * _item.amount * _item.quantity;
    });
    return normTwoDecimal(round(_selectedItemsSum, 2).toString());
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
    _clearSelected();
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
