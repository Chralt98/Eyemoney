import 'dart:async';

import 'package:Eyemoney/custom_widgets/adding/add_category_textfield.dart';
import 'package:Eyemoney/custom_widgets/adding/amount_textfield.dart';
import 'package:Eyemoney/custom_widgets/adding/btn_adding_check.dart';
import 'package:Eyemoney/custom_widgets/adding/category_item.dart';
import 'package:Eyemoney/custom_widgets/adding/category_list.dart';
import 'package:Eyemoney/custom_widgets/adding/description_textfield.dart';
import 'package:Eyemoney/custom_widgets/adding/list_decoration.dart';
import 'package:Eyemoney/custom_widgets/adding/selected_category.dart';
import 'package:Eyemoney/custom_widgets/adding/sign_selector.dart';
import 'package:Eyemoney/custom_widgets/dismissible_background.dart';
import 'package:Eyemoney/database/transaction.dart';
import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:Eyemoney/outsourcing/my_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../outsourcing/global_vars.dart';
import '../outsourcing/my_functions.dart';

class Adding extends StatefulWidget {
  static const routeName = '/adding';

  const Adding({Key key}) : super(key: key);

  @override
  _AddingState createState() => new _AddingState();
}

class _AddingState extends State<Adding> {
  List<String> _categories = List<String>();

  SharedPreferences _prefs;

  String _description;
  String _amount = '0.00';
  String _selectedCategory = '';
  bool isRevenue = false;

  double _balance = 0.0;

  var _moneyController = MoneyMaskedTextController();

  // var _quantityController = TextEditingController(text: '1');
  var _quantityController = MaskedTextController(text: '1', mask: '000');

  int _radioVal = 0;

  final _formKey = GlobalKey<FormState>();

  ScrollController _scrollController;
  TextEditingController _descriptionController;
  TextEditingController _addCategoryController;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _descriptionController = new TextEditingController();
    _addCategoryController = new TextEditingController();
    SharedPreferences.getInstance()
      ..then(
        (prefs) {
          _prefs = prefs;
          _loadCategoryPref(context);
          _initDefaultValues();
          _moneyController.addListener(_calculateNewBalance);
        },
      );
  }

  void _calculateNewBalance() {
    final AddingArguments args = ModalRoute.of(context).settings.arguments;
    if (_moneyController.numberValue == 0.0) {
      setState(() {
        _balance = args.balance ?? 0.0;
      });
    } else {
      double quantity;
      if (deleteSpaces(_quantityController.text) == '' ||
          _quantityController.text == null) {
        quantity = 1.0;
      } else {
        quantity = double.parse(_quantityController.text ?? 1.0);
      }
      setState(() {
        _balance = round(
            args.balance +
                (isRevenue ? 1 : -1) * _moneyController.numberValue * quantity,
            2);
      });
    }
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
    final _listTiles = _getListTiles();
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Theme.of(context).accentColor,
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
                  SizedBox(height: 26),
                  SignSelector(
                    mySwitch: _getSwitch(),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Text(AppLocalizations.of(context).balance +
                      ': ' +
                      _balance.toString()),
                  SizedBox(
                    height: 13,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AmountTextField(
                            moneyController: _moneyController,
                            submitCallback: _onSubmitAmount,
                            validatorCallback: _onValidateAmount),
                      ),
                      Icon(Icons.clear),
                      Container(
                        width: 55,
                        child: TextField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          onTap: () => _quantityController.text = '',
                          onChanged: (text) {
                            _calculateNewBalance();
                          },
                          controller: _quantityController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 26),
                  DescriptionTextField(
                    onChanged: _descriptionTextFieldChanged,
                    descriptionController: _descriptionController,
                  ),
                  SizedBox(height: 13),
                  AddCategoryTextField(
                    onSubmitted: _addCategoryTextFieldOnSubmitted,
                    addCategoryController: _addCategoryController,
                  ),
                  SizedBox(height: 13),
                  SelectedCategory(
                    selectedCategory: _selectedCategory,
                  ),
                  SizedBox(height: 13),
                  CategoryList(
                      tiles: _listTiles, reorderCallback: _onReorderCategories),
                ],
              ),
            ),
            controller: _scrollController,
          ),
          AddingCheck(
            onPressed: () => _onCheck(),
            isVisible:
                MediaQuery.of(context).viewInsets.bottom == 0 ? true : false,
          ),
        ],
      ),
    );
  }

  List<Dismissible> _getListTiles() {
    return _categories.map((item) {
      final index = _categories.indexOf(item);
      return Dismissible(
        key: Key(item.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (DismissDirection dir) {
          if (dir == DismissDirection.endToStart) {
            _deleteCategory(item);
            showToast(item + ' ' + AppLocalizations.of(context).removed);
          }
        },
        background: DismissibleBackground(),
        child: ListDecoration(
          index: index,
          tile: RadioListTile<int>(
            value: index,
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
            activeColor: Theme.of(context).primaryColor,
            title: CategoryItem(
              item: item,
            ),
          ),
        ),
      );
    }).toList();
  }

  void _initDefaultValues() {
    final AddingArguments args = ModalRoute.of(context).settings.arguments;
    _balance = args.balance ?? 0.0;
    _selectedCategory = _categories.first ?? AppLocalizations.of(context).other;
    if (args.myTransaction != null) {
      double temp = ((args.myTransaction.amount < 0
          ? args.myTransaction.amount * -1
          : args.myTransaction.amount));
      _amount = temp.toString() ?? '0.00';
      _moneyController.updateValue(temp);
      _quantityController.text = args.myTransaction.quantity.toString();
      _description = args.myTransaction.description;
      _descriptionController.text = _description;
      _selectedCategory = args.myTransaction.category;
      _setCategory(_selectedCategory);
      bool transactionSign = args.myTransaction.amount >= 0 ? true : false;
      isRevenue = transactionSign;
    } else {
      isRevenue = false;
    }
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
    if (number == '0,00') {
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
          onChanged: (bool value) => setState(
            () {
              isRevenue = value;
              _calculateNewBalance();
            },
          ),
          activeColor: Colors.lightGreen,
          inactiveThumbColor: Colors.red,
          inactiveTrackColor: Color.fromARGB(120, 255, 0, 0),
        ),
      ),
    );
  }

  void _descriptionTextFieldChanged(String text) {
    _description = deleteSpaces(text);
  }

  void _addCategoryTextFieldOnSubmitted(String text) {
    _setCategory(text);
  }

  void _setCategory(String category) async {
    category = deleteSpaces(category);
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

  void _onCheck() {
    if (_addCategoryController.text != '' &&
        _addCategoryController.text != _selectedCategory) {
      _setCategory(_addCategoryController.text);
    }
    if (_formKey.currentState.validate()) {
      _insertOrUpdateDatabase();
      try {
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }
  }

  void _insertOrUpdateDatabase() async {
    _amount = _moneyController.numberValue.toString();
    final int sign = isRevenue ? 1 : -1;

    _description = _description == '' ? '–' : _description;

    int _quantity = 1;
    if (_quantityController.text != '') {
      _quantity = int.parse(_quantityController.text);
    }
    final double _realAmount = round((sign) * double.parse(_amount), 2);

    final AddingArguments args = ModalRoute.of(context).settings.arguments;

    final MyTransaction data = MyTransaction(
      id: (args.myTransaction != null) ? args.myTransaction.id : null,
      category: _selectedCategory,
      description: _description,
      amount: _realAmount,
      quantity: _quantity,
      date: DateTime((args.selectedDate ?? DateTime.now()).year,
              (args.selectedDate ?? DateTime.now()).month)
          .toString(),
    );

    if (args.myTransaction != null) {
      await updateTransaction(data);
    } else {
      await insertInDatabase(data);
    }
  }
}
