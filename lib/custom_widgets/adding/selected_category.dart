import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

class SelectedCategory extends StatelessWidget {
  final String selectedCategory;

  SelectedCategory({@required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: FittedBox(
        child: Text(
          (AppLocalizations.of(context).category + ': ' + selectedCategory)
              .toString(),
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }
}
