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
          style: Theme.of(context).textTheme.body1,
        ),
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
