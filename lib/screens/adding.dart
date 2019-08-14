import 'dart:async';

import 'package:Eyemoney/custom_widgets/adding/add_category_textfield.dart';
import 'package:Eyemoney/custom_widgets/adding/amount_textfield.dart';
import 'package:Eyemoney/custom_widgets/adding/btn_adding_check.dart';
import 'package:Eyemoney/custom_widgets/adding/category_item.dart';
import 'package:Eyemoney/custom_widgets/adding/description_textfield.dart';
import 'package:Eyemoney/custom_widgets/adding/list_decoration.dart';
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
  String _selectedCategory = '';
  var _moneyController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  int _radioVal = 0;
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController;
  TextEditingController _descriptionController;
  TextEditingController _addCategoryController;
  bool isRevenue = false;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _descriptionController = new TextEditingController();
    _addCategoryController = new TextEditingController();
    SharedPreferences.getInstance()
      ..then(
        (prefs) {
          setState(() => _prefs = prefs);
          _loadCategoryPref(context);
          _selectedCategory =
              _categories.first ?? AppLocalizations.of(context).other;
          if (widget.myTransaction != null) {
            double temp = ((widget.myTransaction.amount < 0
                ? widget.myTransaction.amount * -1
                : widget.myTransaction.amount));
            _amount = temp.toString() ?? '0.00';
            _moneyController.updateValue(temp);
            bool transactionSign =
                widget.myTransaction.amount >= 0 ? true : false;
            isRevenue = transactionSign;
            _description = widget.myTransaction.description;
            _descriptionController.text = _description;
            _selectedCategory = widget.myTransaction.category;
            _setCategory(_selectedCategory);
          } else {
            isRevenue = false;
          }
        },
      );
  }

  @override
  void dispose() {
    _addCategoryController.dispose();
    _scrollController.dispose();
    _moneyController.dispose();
    _descriptionController.dispose();
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
                _deleteCategory(item);
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
            child: ListDecoration(
              index: _categories.indexOf(item),
              tile: RadioListTile<int>(
                value: _categories.indexOf(item),
                groupValue: _radioVal,
                onChanged: (int value) {
                  setState(
                    () {
                      _radioVal = value;
                      _selectedCategory = item;
                    },
                  );
                },
                secondary: Icon(Icons.dehaze),
                activeColor: Colors.blue,
                title: CategoryItem(
                  item: item,
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
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 120, top: 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40),
                  AmountTextField(
                      moneyController: _moneyController,
                      submitCallback: _onSubmitAmount,
                      validatorCallback: _onValidateAmount),
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
                  Text((AppLocalizations.of(context).category +
                          ': ' +
                          _selectedCategory)
                      .toString()),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      height: 282,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
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
          AddingCheck(onPressed: () => _onCheck()),
        ],
      ),
    );
  }

  void _deleteCategory(String item) {
    int _selectedIndex = _categories.indexOf(_selectedCategory);
    int _index = _categories.indexOf(item);
    _categories.removeAt(_index);
    if (_index < _selectedIndex) {
      _radioVal--;
    }
    if (_categories.isEmpty) {
      _categories.insert(0, AppLocalizations.of(context).other);
      _radioVal = 0;
    } else if (_categories.isNotEmpty && _selectedCategory == item) {
      _radioVal = 0;
    }
    // _selectedCategory is now set
    _selectedCategory = _categories[_radioVal];
    setState(() {
      _setCategoryPref(_categories);
    });
  }

  void _onReorderCategories(int oldIndex, int newIndex) {
    String old = _categories[oldIndex];
    if (oldIndex > newIndex) {
      for (int i = oldIndex; i > newIndex; i--) {
        _categories[i] = _categories[i - 1];
      }
      _categories[newIndex] = old;
      _radioVal = newIndex;
      _selectedCategory = _categories[_radioVal];
    } else {
      for (int i = oldIndex; i < newIndex - 1; i++) {
        _categories[i] = _categories[i + 1];
      }
      _categories[newIndex - 1] = old;
      _radioVal = newIndex - 1;
      _selectedCategory = _categories[_radioVal];
    }
    setState(() {
      _setCategoryPref(_categories);
    });
  }

  // only category for shared preferences
  void _loadCategoryPref(BuildContext context) {
    setState(
      () {
        _categories = _prefs.getStringList(categoryPrefKey) ??
            getStandardCategories(context);
      },
    );
  }

  Future<Null> _setCategoryPref(List<String> categories) async {
    await _prefs.setStringList(categoryPrefKey, categories);
    _loadCategoryPref(context);
  }

  String _onValidateAmount(String number) {
    if (number == '0.00') {
      _scrollController.animateTo(0,
          duration: new Duration(milliseconds: 500), curve: Curves.ease);
      return AppLocalizations.of(context).amountDescription;
    }
    return null;
  }

  void _onSubmitAmount(String text) {
    _amount = text;
  }

  Widget _getSwitch() {
    return Container(
      child: Transform.scale(
        scale: 2,
        child: Switch(
          value: isRevenue,
          onChanged: (bool value) => setState(() => isRevenue = value),
          activeColor: Colors.lightGreen,
          inactiveThumbColor: Colors.red,
          inactiveTrackColor: Color.fromARGB(120, 255, 0, 0),
        ),
      ),
    );
  }

  void _descriptionTextFieldChanged(String text) {
    _description = text;
  }

  void _addCategoryTextFieldOnSubmitted(String text) {
    _setCategory(text);
  }

  void _setCategory(String category) async {
    if (category.length == category.split(' ').length - 1) {
      // here the category would set empty if only spaces
      category = category.replaceAll(' ', '');
    }
    if (_categories.contains(category)) {
      _selectedCategory = category;
      _radioVal = _categories.indexOf(_selectedCategory);
    } else if (!_categories.contains(category) && category.isNotEmpty) {
      _radioVal = 0;
      _categories.insert(_radioVal, category);
      _selectedCategory = _categories[_radioVal];
    } else if (!_categories.contains(category) && category.isEmpty) {
      _radioVal = 0;
      _selectedCategory = _categories[_radioVal];
    }
    await _setCategoryPref(_categories);
    _addCategoryController.text = '';
  }

  void _onCheck() async {
    if (_addCategoryController.text != '' &&
        _addCategoryController.text != _selectedCategory) {
      _setCategory(_addCategoryController.text);
    }
    if (_formKey.currentState.validate()) {
      _amount = _moneyController.numberValue.toString();
      final int sign = isRevenue ? 1 : -1;
      final double _realAmount = round((sign) * double.parse(_amount), 2);
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
        await updateTransaction(data);
      } else {
        final MyTransaction data = MyTransaction(
          category: _selectedCategory,
          description: _description,
          amount: _realAmount,
          date: DateTime((widget.selectedDate ?? DateTime.now()).year,
                  (widget.selectedDate ?? DateTime.now()).month)
              .toString(),
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
