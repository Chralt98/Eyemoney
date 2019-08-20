import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

class ListTileCategory extends StatelessWidget {
  final String category;

  ListTileCategory({@required this.category});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(width: 1, color: Colors.black12), right: BorderSide(width: 1, color: Colors.black12)),
        ),
        child: Text(
          category ?? AppLocalizations.of(context).other,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }
}
