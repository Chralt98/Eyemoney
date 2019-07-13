import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'overlay.dart';

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    final _biggerFont = const TextStyle(fontSize: 18.0);
    List<String> categories = List<String>();

    void _addCategory(String name) {
      categories.add(name);
    }

    Widget _buildRow(int index) {
      return ListTile(
        leading: Icon(Icons.arrow_right),
        title: Text(
          'Test $index',
          style: _biggerFont,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: categories.length * 2,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2 + 1;
          return _buildRow(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () => showPopup(context, _popupBody(), 'Add'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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
                    } catch (e) {}
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

  Widget _popupBody() {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Center(
            child: TextField(
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.title,
          decoration: InputDecoration(
              hintText: 'e. g. rent',
              labelText: 'category',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        )));
  }
}
