import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

class Statistics extends StatelessWidget {
  static const routeName = '/statistics';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).statistics),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Container(),
    );
  }
}
