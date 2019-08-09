import 'package:Eyemoney/outsourcing/globals.dart';
import 'package:Eyemoney/screens/add_category.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        padding: EdgeInsets.only(bottom: 90, top: 26, left: 16, right: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final String item = _categories[index] ?? '';
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
              background: Container(
                color: Colors.red,
                child: Icon(Icons.delete),
                alignment: Alignment.centerRight,
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: (index % 2 == 0)
                        ? Color.fromARGB(5, 255, 255, 0)
                        : Color.fromARGB(5, 0, 0, 255),
                    border: Border.fromBorderSide(BorderSide(
                        width: 0.0,
                        color: Colors.black12,
                        style: BorderStyle.solid))),
                child: ListTile(
                  leading: Icon(Icons.dehaze),
                  title: Container(
                      child: Text(
                    item,
                    style: _biggerFont,
                    textScaleFactor: (item.toString().length > 18) ? 0.65 : 1.0,
                  )),
                ),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          String category = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddCategory()));
          if (category != null) {
            this._categories.add(category);
            this._setCategoryPref(this._categories);
            this._loadCategoryPref();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _loadCategoryPref() {
    setState(() {
      this._categories =
          this._prefs.getStringList(categoryPrefKey) ?? standard_categories;
    });
  }

  Future<Null> _setCategoryPref(List<String> categories) async {
    await this._prefs.setStringList(categoryPrefKey, categories);
    _loadCategoryPref();
  }
}
