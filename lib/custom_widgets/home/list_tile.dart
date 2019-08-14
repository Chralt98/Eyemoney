import 'package:Eyemoney/custom_widgets/home/list_tile_amount.dart';
import 'package:Eyemoney/custom_widgets/home/list_tile_category.dart';
import 'package:Eyemoney/custom_widgets/home/list_tile_description.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String description;
  final String category;
  final double amount;
  final int index;

  MyListTile({@required this.description, @required this.category, @required this.amount, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5, top: 5),
      decoration: BoxDecoration(
          color: (index % 2 == 0) ? Color.fromARGB(5, 255, 255, 0) : Color.fromARGB(5, 0, 0, 255),
          border: Border.fromBorderSide(BorderSide(width: 0.0, color: Colors.black12, style: BorderStyle.solid))),
      child: Row(
        children: <Widget>[
          ListTileDescription(description: description),
          ListTileCategory(category: category),
          ListTileAmount(
            amount: amount,
          ),
        ],
      ),
    );
  }
}
