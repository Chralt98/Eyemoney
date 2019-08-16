import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

class ListInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: Column(
              children: <Widget>[
                _getLabel(context, AppLocalizations.of(context).description),
                _getSymbol(context, Icons.info_outline),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                _getLabel(context, AppLocalizations.of(context).category),
                _getSymbol(context, Icons.category),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                _getLabel(context, AppLocalizations.of(context).money),
                _getSymbol(context, Icons.fiber_smart_record),
              ],
            ),
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
        child: Icon(symbol),
      ),
    );
  }
}
