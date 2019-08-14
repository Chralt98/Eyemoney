import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String item;

  CategoryItem({@required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: FittedBox(
        alignment: Alignment.centerLeft,
        child: Text(
          item,
        ),
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
