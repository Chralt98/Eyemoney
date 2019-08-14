import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

class SignSelector extends StatelessWidget {
  final Widget mySwitch;

  SignSelector({@required this.mySwitch});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
        children: <Widget>[
          SizedBox(
            width: 40,
          ),
          Text(AppLocalizations.of(context).expenditure, style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(width: 15),
          mySwitch,
          SizedBox(width: 15),
          Text(AppLocalizations.of(context).revenue, style: TextStyle(color: Colors.lightGreen, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
      ),
    );
  }
}
