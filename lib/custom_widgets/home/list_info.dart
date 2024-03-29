import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

class ListInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          top: BorderSide(width: 1, color: Colors.black12),
          bottom: BorderSide(width: 2, color: Colors.black12),
        ),
      ),
      height: 54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                _getLabel(context, AppLocalizations.of(context).description),
                _getSymbol(context, Icons.info_outline),
              ],
            ),
            width: screenWidth / 3,
          ),
          Container(
            child: Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(width: 1, color: Colors.black12), right: BorderSide(width: 1, color: Colors.black12)),
              ),
              child: Column(
                children: <Widget>[
                  _getLabel(context, AppLocalizations.of(context).category),
                  _getSymbol(context, Icons.category),
                ],
              ),
            ),
            width: screenWidth / 3,
          ),
          Container(
            child: Column(
              children: <Widget>[
                _getLabel(context, AppLocalizations.of(context).money),
                _getSymbol(context, Icons.fiber_smart_record),
              ],
            ),
            width: screenWidth / 3,
          ),
        ],
      ),
    );
  }

  Widget _getLabel(BuildContext context, String label) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            label,
          ),
        ),
      ),
    );
  }

  Widget _getSymbol(BuildContext context, IconData symbol) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Icon(
          symbol,
          color: Colors.black45,
        ),
      ),
    );
  }
}
