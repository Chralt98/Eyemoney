import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final List<Dismissible> tiles;
  final ReorderCallback reorderCallback;

  CategoryList({@required this.tiles, @required this.reorderCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        height: 282,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ReorderableListView(
          children: tiles,
          scrollDirection: Axis.vertical,
          onReorder: reorderCallback,
        ),
      ),
    );
  }
}
