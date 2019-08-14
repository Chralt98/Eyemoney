import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

class SignSelector extends StatelessWidget {
  final Widget mySwitch;

  SignSelector({@required this.mySwitch});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      width: screenWidth,
      child: FittedBox(
        child: Row(children: <Widget>[
          Text(
            AppLocalizations.of(context).expenditure,
            style: TextStyle(
                color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 15),
          mySwitch,
          SizedBox(width: 15),
          Text(
            AppLocalizations.of(context).revenue,
            style: TextStyle(
                color: Colors.lightGreen,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    );
  }
}
