import 'package:Eyemoney/custom_widgets/home/list_tile_amount.dart';
import 'package:Eyemoney/custom_widgets/home/list_tile_category.dart';
import 'package:Eyemoney/custom_widgets/home/list_tile_description.dart';
import 'package:flutter/material.dart';

typedef ChangeCallback(bool value);

class MyListTile extends StatelessWidget {
  final String description;
  final String category;
  final double amount;
  final int index;
  final bool isSelected;
  final ChangeCallback onChanged;
  final bool isVisible;

  MyListTile(
      {@required this.description,
      @required this.category,
      @required this.amount,
      @required this.index,
      @required this.isSelected,
      @required this.onChanged,
      @required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (index % 2 == 0) ? Color.fromARGB(5, 255, 255, 0) : Color.fromARGB(5, 0, 0, 255),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ListTileDescription(description: description),
              ListTileCategory(category: category),
              ListTileAmount(amount: amount),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Visibility(visible: isVisible, child: Checkbox(value: isSelected, onChanged: onChanged)),
          ),
        ],
      ),
    );
  }
}
