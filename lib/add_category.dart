import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  final List<String> categories;

  const AddCategory({Key key, @required this.categories}) : super(key: key);

  @override
  _AddCategoryState createState() => new _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  String _category;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Add'),
          actions: [],
        ),
        body: new Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          new SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Center(
                  child: TextField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.category),
                  hintText: 'Which should be added?',
                  labelText: 'category',
                ),
                onChanged: (text) => this._category = text,
                keyboardType: TextInputType.text,
                maxLength: 15,
              ))),
          Container(
            child: new FloatingActionButton(
              child: Icon(Icons.check),
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                try {
                  List<String> temp = widget.categories;
                  temp.add(_category);
                  Navigator.pop(context, temp);
                } catch (e) {
                  print(e);
                }
              },
            ),
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.all(16),
          )
        ]));
  }
}
