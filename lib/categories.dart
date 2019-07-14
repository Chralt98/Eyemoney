import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'overlay.dart';

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  SharedPreferences _prefs;
  static const String categoryPrefKey = 'category_pref';
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
        onPressed: () => showPopup(
            context, _popupBody('e.g. electronics', 'category'), 'Add'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _loadCategoryPref() {
    setState(() {
      this._prefs.getString(categoryPrefKey) ?? 'electronics';
    });
  }

  Future<Null> _setCategoryPref(List<String> category) async {
    await this._prefs.setList(categoryPrefKey, category);
    _loadCategoryPref();
  }

  // TODO: at the end of screen save the categorys in prefs every time
  // overwrite it every time the user leaves the screen
  // but before load it to set the current cateogries list

  void _addCategory(String name) {
    _categories.add(name);
  }

  showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    double height = MediaQuery.of(context).size.height;
    Navigator.push(
      context,
      TextInputOverlay(
        top: height * 0.3,
        left: 50,
        right: 50,
        bottom: height * 0.4,
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
            child: TextField(
          onSubmitted: (text) {
            this._addCategory(text);
            try {
              Navigator.pop(context); //close the popup
            } catch (e) {
              print(e);
            }
          },
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.title,
          decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        )));
  }
}
