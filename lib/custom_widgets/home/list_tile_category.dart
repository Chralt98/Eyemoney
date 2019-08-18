import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

class ListTileCategory extends StatelessWidget {
  final String category;

  ListTileCategory({@required this.category});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Text(
        category ?? AppLocalizations.of(context).other,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.body1,
      ),
      width: screenWidth / 3,
    );
  }
}
