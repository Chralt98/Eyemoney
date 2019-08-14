import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

class CategoryField extends StatelessWidget {
  CategoryField();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.category,
            color: Colors.grey,
          ),
          SizedBox(width: 15),
          Text(
            AppLocalizations.of(context).category,
            style: TextStyle(color: Colors.black54),
            textScaleFactor: 1.5,
          ),
        ],
      ),
    );
  }
}
