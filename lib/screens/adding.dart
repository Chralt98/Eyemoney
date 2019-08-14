import 'dart:async';

import 'package:Eyemoney/custom_widgets/adding/add_category_textfield.dart';
import 'package:Eyemoney/custom_widgets/adding/amount_textfield.dart';
import 'package:Eyemoney/custom_widgets/adding/btn_adding_check.dart';
import 'package:Eyemoney/custom_widgets/adding/description_textfield.dart';
import 'package:Eyemoney/custom_widgets/adding/sign_selector.dart';
import 'package:Eyemoney/custom_widgets/dismissible_background.dart';
import 'package:Eyemoney/database/transaction.dart';
import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../outsourcing/globals.dart';
import '../outsourcing/my_functions.dart';

class Adding extends StatefulWidget {
  final DateTime selectedDate;
  final MyTransaction myTransaction;

  const Adding({Key key, @required this.selectedDate, this.myTransaction}) : super(key: key);

  @override
  _AddingState createState() => new _AddingState();
}

class _AddingState extends State<Adding> {
  List<String> _categories = List<String>();
  SharedPreferences _prefs;
  String _description;
  String _amount = '0.00';
  String _selectedCategory;
  var _moneyController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  int _radioVal = 0;
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController;
  TextEditingController _descriptionController;
  TextEditingController _addCategoryController;
  bool isRevenue = false;

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
          _selectedCategory = AppLocalizations.of(context).other;
          this._loadCategoryPref(context);
          if (widget.myTransaction != null) {
            double temp = ((widget.myTransaction.amount < 0 ? widget.myTransaction.amount * -1 : widget.myTransaction.amount));
            this._amount = temp.toString() ?? '0.00';
            _moneyController.updateValue(temp);
            bool transactionSign = widget.myTransaction.amount >= 0 ? true : false;
            this.isRevenue = transactionSign;
            this._description = widget.myTransaction.description;
            this._descriptionController.text = this._description;
            this._selectedCategory = widget.myTransaction.category;
            this._setCategory(this._selectedCategory);
          } else {
            this.isRevenue = false;
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
                    this._deleteCategory(item);
                    this._setCategoryPref(this._categories);
                  },
                );

                Fluttertoast.showToast(
                  msg: item + ' ' + AppLocalizations.of(context).removed,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  fontSize: 16.0,
                );
              }
            },
            background: DismissibleBackground(),
            child: Container(
              decoration: BoxDecoration(
                  color: (_categories.indexOf(item) % 2 == 0) ? Color.fromARGB(5, 255, 255, 0) : Color.fromARGB(5, 0, 0, 255),
                  border: Border.fromBorderSide(BorderSide(width: 0.0, color: Colors.black12, style: BorderStyle.solid))),
              child: RadioListTile<int>(
                value: _categories.indexOf(item),
                groupValue: this._radioVal,
                onChanged: (int value) {
                  setState(
                    () {
                      this._radioVal = value;
                      this._selectedCategory = item;
                    },
                  );
                },
                secondary: Icon(Icons.dehaze),
                activeColor: Colors.blue,
                title: Container(
                  height: 48,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item,
                    ),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
    return new Scaffold(
      appBar: new AppBar(
        title: Text(AppLocalizations.of(context).add),
        actions: [],
      ),
      body: new Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          new SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120, top: 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40),
                  AmountTextField(moneyController: _moneyController, submitCallback: _onSubmitAmount, validatorCallback: _onValidateAmount),
                  SizedBox(height: 26),
                  DescriptionTextField(
                    onChanged: _descriptionTextFieldChanged,
                    descriptionController: _descriptionController,
                  ),
                  SizedBox(height: 13),
                  SignSelector(
                    mySwitch: _getSwitch(),
                  ),
                  SizedBox(height: 26),
                  AddCategoryTextField(
                    onSubmitted: _addCategoryTextFieldOnSubmitted,
                    addCategoryController: _addCategoryController,
                  ),
                  SizedBox(height: 26),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      height: 282,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 1), borderRadius: BorderRadius.circular(5)),
                      child: ReorderableListView(
                        children: _listTiles,
                        scrollDirection: Axis.vertical,
                        onReorder: _onReorderCategories,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            controller: _scrollController,
          ),
          AddingCheck(onPressed: () => this._onCheck()),
        ],
      ),
    );
  }

  void _deleteCategory(String item) {
    int _selectedIndex = _categories.indexOf(_selectedCategory);
    int _index = _categories.indexOf(item);
    this._categories.removeAt(_index);
    if (_index < _selectedIndex) {
      this._radioVal--;
    }
    if (this._categories.isEmpty) {
      _categories.insert(0, AppLocalizations.of(context).other);
      this._radioVal = 0;
    } else if (this._categories.isNotEmpty && this._selectedCategory == item) {
      this._radioVal = 0;
    }
  }

  void _onReorderCategories(int oldIndex, int newIndex) {
    String old = this._categories[oldIndex];
    if (oldIndex > newIndex) {
      for (int i = oldIndex; i > newIndex; i--) {
        this._categories[i] = this._categories[i - 1];
      }
      this._categories[newIndex] = old;
      this._radioVal = newIndex;
    } else {
      for (int i = oldIndex; i < newIndex - 1; i++) {
        this._categories[i] = this._categories[i + 1];
      }
      this._categories[newIndex - 1] = old;
      this._radioVal = newIndex - 1;
    }
    setState(() {
      this._setCategoryPref(this._categories);
    });
  }

  // only category for shared preferences
  void _loadCategoryPref(BuildContext context) {
    setState(
      () {
        _categories = this._prefs.getStringList(categoryPrefKey) ?? getStandardCategories(context);
      },
    );
  }

  Future<Null> _setCategoryPref(List<String> categories) async {
    await this._prefs.setStringList(categoryPrefKey, categories);
    _loadCategoryPref(context);
  }

  String _onValidateAmount(String number) {
    if (number == '0.00') {
      _scrollController.animateTo(0, duration: new Duration(milliseconds: 500), curve: Curves.ease);
      return AppLocalizations.of(context).amountDescription;
    }
    return null;
  }

  void _onSubmitAmount(String text) {
    this._amount = text;
  }

  Widget _getSwitch() {
    return Container(
      child: Transform.scale(
        scale: 1.5,
        child: Switch(
          value: this.isRevenue,
          onChanged: (bool value) => setState(() => this.isRevenue = value),
          activeColor: Colors.lightGreen,
          inactiveThumbColor: Colors.red,
          inactiveTrackColor: Colors.redAccent,
        ),
      ),
    );
  }

  void _descriptionTextFieldChanged(String text) {
    this._description = text;
  }

  void _addCategoryTextFieldOnSubmitted(String text) {
    this._setCategory(text);
  }

  void _setCategory(String category) async {
    if (category.length == category.split(' ').length - 1) {
      category = category.replaceAll(' ', '');
    }
    if (this._categories.contains(category)) {
      this._selectedCategory = category;
      this._radioVal = this._categories.indexOf(category);
    } else if (!_categories.contains(category) && category.isNotEmpty) {
      this._categories.add(category);
      this._selectedCategory = category;
      this._radioVal = this._categories.indexOf(category);
    } else {
      this._selectedCategory = AppLocalizations.of(context).other;
      this._radioVal = 0;
    }
    await this._setCategoryPref(this._categories);
    this._addCategoryController.text = '';
  }

  void _onCheck() async {
    if (this._addCategoryController.text != '' && this._addCategoryController.text != this._selectedCategory) {
      this._setCategory(this._addCategoryController.text);
    }
    if (_formKey.currentState.validate()) {
      this._amount = _moneyController.numberValue.toString();
      final int sign = this.isRevenue ? 1 : -1;
      final double _realAmount = round((sign) * double.parse(_amount), 2);
      if (widget.myTransaction != null) {
        final MyTransaction data = MyTransaction(
          id: widget.myTransaction.id,
          category: this._selectedCategory,
          description: this._description,
          amount: _realAmount,
          date: DateTime((widget.selectedDate ?? DateTime.now()).year, (widget.selectedDate ?? DateTime.now()).month).toString(),
        );
        await updateTransaction(data);
      } else {
        final MyTransaction data = MyTransaction(
          category: _selectedCategory,
          description: _description,
          amount: _realAmount,
          date: DateTime((widget.selectedDate ?? DateTime.now()).year, (widget.selectedDate ?? DateTime.now()).month).toString(),
        );
        await insertInDatabase(data);
      }
      try {
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }
  }
}
