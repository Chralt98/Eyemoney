import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

class ListInfoLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _getLabel(context, AppLocalizations.of(context).description),
          _getLabel(context, AppLocalizations.of(context).category),
          _getLabel(context, AppLocalizations.of(context).amount),
        ],
      ),
    );
  }

  Widget _getLabel(BuildContext context, String label) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      child: FittedBox(
        child: Text(
          label,
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 50)),
        ),
        fit: BoxFit.scaleDown,
      ),
      width: screenWidth / 3,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
      ),
    );
  }
}
