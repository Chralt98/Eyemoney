import 'package:Eyemoney/custom_widgets/home/list_tile_amount.dart';
import 'package:Eyemoney/custom_widgets/home/list_tile_category.dart';
import 'package:Eyemoney/custom_widgets/home/list_tile_description.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String description;
  final String category;
  final double amount;
  final int index;
  final bool isSelected;
  final VoidCallback onLongPress;

  MyListTile({@required this.description, @required this.category, @required this.amount, @required this.index, @required this.isSelected, @required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          border: (isSelected) ? (Border(left: BorderSide(width: 5, color: Colors.blue), right: BorderSide(width: 5, color: Colors.blue))) : null,
          color: (index % 2 == 0) ? Color.fromARGB(5, 255, 255, 0) : Color.fromARGB(5, 0, 0, 255),
        ),
        child: Row(
          children: <Widget>[
            ListTileDescription(description: description),
            ListTileCategory(category: category),
            ListTileAmount(amount: amount),
          ],
        ),
      ),
    );
  }
}
