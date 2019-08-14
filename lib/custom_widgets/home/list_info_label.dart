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
      decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(width: 1, color: Colors.black12),
          ),
          color: Colors.white),
      child: Container(
        alignment: Alignment.center,
        child: FittedBox(
          child: Text(
            label,
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 50),
              fontWeight: FontWeight.bold,
            ),
          ),
          fit: BoxFit.scaleDown,
        ),
        width: screenWidth / 3,
      ),
    );
  }
}
