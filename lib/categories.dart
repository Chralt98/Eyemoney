import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';
import 'overlay.dart';

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  SharedPreferences _prefs;
  List<String> _categories = List<String>();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._prefs = prefs);
        _loadCategoryPref();
      });
  }

  @override
  Widget build(BuildContext context) {
    final _biggerFont = const TextStyle(fontSize: 20.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        padding: const EdgeInsets.all(25.0),
        itemBuilder: (context, index) {
          final String item = _categories[index];
          return Dismissible(
            key: Key(item),
            direction: DismissDirection.endToStart,
            onDismissed: (DismissDirection dir) {
              if (dir == DismissDirection.endToStart) {
                setState(() => this._categories.remove(_categories[index]));
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('$item removed.'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      setState(() => this._categories.insert(index, item));
                    },
                  ),
                ));
              }
              this._setCategoryPref(_categories);
            },
            secondaryBackground: Container(
              color: Colors.red,
              child: Icon(Icons.delete),
              alignment: Alignment.centerRight,
            ),
            background: Container(
              color: Colors.transparent,
              child: Icon(Icons.edit),
              alignment: Alignment.centerLeft,
            ),
            child: ListTile(
              leading: Icon(Icons.dehaze),
              title: Text(
                item,
                style: _biggerFont,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () => _showPopup(context, _popupBody('e.g. electronics', 'category'), 'Add'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _loadCategoryPref() {
    setState(() {
      this._categories = this._prefs.getStringList(categoryPrefKey) ?? standard_categories;
    });
  }

  Future<Null> _setCategoryPref(List<String> categories) async {
    await this._prefs.setStringList(categoryPrefKey, categories);
    _loadCategoryPref();
  }

  void _addCategory(String name) {
    _categories.add(name);
    this._setCategoryPref(_categories);
  }

  _showPopup(BuildContext context, Widget widget, String title, {BuildContext popupContext}) {
    final double height = MediaQuery.of(context).size.height;
    Navigator.push(
      context,
      MyOverlay(
        top: 100,
        left: 50,
        right: 50,
        bottom: height - 300,
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

  Widget _popupBody(String hintText, String labelText) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Center(
            child: TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            icon: Icon(Icons.category),
            hintText: 'e.g. electronics',
            labelText: 'category',
          ),
          onFieldSubmitted: (text) {
            this._addCategory(text);
            try {
              Navigator.pop(context); //close the popup
            } catch (e) {
              print(e);
            }
          },
          keyboardType: TextInputType.text,
        )));
  }
}
