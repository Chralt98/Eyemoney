import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_category.dart';
import 'globals.dart';

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  SharedPreferences _prefs;
  List<String> _categories;

  @override
  void initState() {
    super.initState();
    _categories = List<String>();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._prefs = prefs);
        _loadCategoryPref();
      });
  }

  @override
  Widget build(BuildContext context) {
    final _biggerFont = const TextStyle(fontSize: 16.0);

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
        onPressed: () async {
          this._categories.add(await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddCategory())));
          this._setCategoryPref(_categories);
        },
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
}
