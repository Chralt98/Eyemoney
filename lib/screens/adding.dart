import 'dart:async';

import 'package:Eyemoney/custom_widgets/switch.dart';
import 'package:Eyemoney/database/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../outsourcing/globals.dart';
import '../outsourcing/my_functions.dart';

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
  TextEditingController _addCategoryController;

  @override
  void initState() {
    super.initState();
    this._scrollController = new ScrollController();
    this._descriptionController = new TextEditingController();
    this._addCategoryController = new TextEditingController();
    SharedPreferences.getInstance()
      ..then(
        (prefs) {
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
        },
      );
  }

  @override
  void dispose() {
    this._addCategoryController.dispose();
    this._scrollController.dispose();
    this._moneyController.dispose();
    this._descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _listTiles = _categories
        .map(
          (item) => Dismissible(
            key: Key(item.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (DismissDirection dir) {
              if (dir == DismissDirection.endToStart) {
                setState(
                  () {
                    this._categories.removeAt(_categories.indexOf(item));
                    this._setCategoryPref(this._categories);
                  },
                );
              }
            },
            background: Container(
              color: Colors.red,
              child: Icon(Icons.delete),
              alignment: Alignment.centerRight,
            ),
            child: Container(
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
                  setState(
                    () {
                      this._radioVal = value;
                      _selectedCategory = item;
                    },
                  );
                },
                activeColor: Colors.blue,
                title: Container(
                  child: Text(item,
                      textScaleFactor:
                          (item.toString().length > 18) ? 0.65 : 1.0),
                ),
              ),
            ),
          ),
        )
        .toList();
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Add'),
        actions: [],
      ),
      body: new Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          new SingleChildScrollView(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 120, top: 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40),
                  this._getAmountTextField(context),
                  SizedBox(height: 26),
                  this._getDescriptionTextField(context),
                  SizedBox(height: 13),
                  this._getSignSelection(context),
                  SizedBox(height: 26),
                  this._getCategoryField(context),
                  SizedBox(height: 26),
                  Column(
                    children: _listTiles,
                  ),
                  SizedBox(height: 26),
                  this._getAddCategoryTextField(context),
                ],
              ),
            ),
            controller: _scrollController,
          ),
          Container(
            child: new FloatingActionButton(
              child: Icon(Icons.check),
              backgroundColor: Colors.blueAccent,
              onPressed: () async {
                this._onCheck();
              },
            ),
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.all(16),
          )
        ],
      ),
    );
  }

  // only category for shared preferences
  void _loadCategoryPref() {
    setState(
      () {
        _categories =
            this._prefs.getStringList(categoryPrefKey) ?? standardCategories;
        if (_categories.isEmpty) {
          _categories.insert(0, emptyCategory);
        } else if (_categories.isNotEmpty &&
            _categories.first != emptyCategory) {
          _categories.insert(0, emptyCategory);
        }
        if (_categories.isNotEmpty) {
          _selectedCategory = _categories.first;
        }
      },
    );
  }

  Future<Null> _setCategoryPref(List<String> categories) async {
    await this._prefs.setStringList(categoryPrefKey, categories);
    _loadCategoryPref();
  }

  Widget _getAmountTextField(BuildContext context) {
    return TextFormField(
      controller: _moneyController,
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: true),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        filled: true,
        icon: Icon(Icons.attach_money),
        labelText: 'amount *',
      ),
      validator: (String number) {
        if (number == '0.00') {
          _scrollController.animateTo(0,
              duration: new Duration(milliseconds: 500), curve: Curves.ease);
          return 'Please enter an amount!';
        }
        return null;
      },
      onFieldSubmitted: (String number) => this._amount = number,
      // onChanged: (String number) => this._amount = number,
    );
  }

  Widget _getDescriptionTextField(BuildContext context) {
    return TextField(
      textCapitalization: TextCapitalization.words,
      controller: _descriptionController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        filled: true,
        icon: Icon(Icons.info_outline),
        hintText: 'What is it?',
        labelText: 'description',
      ),
      onChanged: (String text) => this._description = text,
      maxLength: 50,
    );
  }

  Widget _getSignSelection(BuildContext context) {
    return Row(
      children: <Widget>[
        OutlineButton(
            onPressed: () {
              setState(() {
                this._crazySwitch = CrazySwitch(isChecked: false);
              });
            },
            child: Text('expenditure',
                style: TextStyle(color: Colors.red), textScaleFactor: 1.1)),
        SizedBox(width: 16),
        this._crazySwitch ?? CrazySwitch(isChecked: false),
        SizedBox(width: 16),
        OutlineButton(
            onPressed: () {
              setState(() {
                this._crazySwitch = CrazySwitch(isChecked: true);
              });
            },
            child: Text('revenue',
                style: TextStyle(color: Colors.lightGreen),
                textScaleFactor: 1.1)),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _getCategoryField(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.category,
            color: Colors.grey,
          ),
          SizedBox(width: 26),
          Text(
            'category',
            style: TextStyle(color: Colors.black54),
            textScaleFactor: 1.5,
          ),
        ],
      ),
    );
  }

  Widget _getAddCategoryTextField(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: TextField(
        textCapitalization: TextCapitalization.words,
        controller: _addCategoryController,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          icon: Icon(Icons.category),
          hintText: 'Which should be added?',
          labelText: 'add category',
        ),
        onChanged: (String text) => _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: new Duration(milliseconds: 500),
            curve: Curves.ease),
        onSubmitted: (String category) async {
          if (!_categories.contains(category)) {
            this._categories.add(category);
          }
          this._radioVal = this._categories.indexOf(category);
          await this._setCategoryPref(this._categories);
          this._selectedCategory = category;
          this._addCategoryController.text = '';
        },
        keyboardType: TextInputType.text,
        maxLength: 25,
      ),
    );
  }

  void _onCheck() async {
    if (_formKey.currentState.validate()) {
      this._amount = _moneyController.numberValue.toString();
      final int sign = _crazySwitch.getChecked() ? 1 : -1;
      final double _realAmount = round(
          (sign) * double.parse(_amount.replaceAll(new RegExp(','), '')), 2);
      if (this._addCategoryController.text != '') {
        if (!_categories.contains(this._addCategoryController.text)) {
          this._categories.add(this._addCategoryController.text);
        }
        this._radioVal =
            this._categories.indexOf(this._addCategoryController.text);
        await this._setCategoryPref(this._categories);
        this._selectedCategory = this._addCategoryController.text;
        this._addCategoryController.text = '';
      }
      if (widget.myTransaction != null) {
        final MyTransaction data = MyTransaction(
          id: widget.myTransaction.id,
          category: _selectedCategory,
          description: _description,
          amount: _realAmount,
          date: DateTime((widget.selectedDate ?? DateTime.now()).year,
                  (widget.selectedDate ?? DateTime.now()).month)
              .toString(),
        );
        updateTransaction(data);
      } else {
        final MyTransaction data = MyTransaction(
          category: _selectedCategory,
          description: _description,
          amount: _realAmount,
          date: DateTime((widget.selectedDate ?? DateTime.now()).year,
                  (widget.selectedDate ?? DateTime.now()).month)
              .toString(),
        );
        insertInDatabase(data);
      }
      try {
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }
  }
}
