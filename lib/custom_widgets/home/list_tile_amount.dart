import 'package:Eyemoney/outsourcing/my_functions.dart';
import 'package:flutter/material.dart';

class ListTileAmount extends StatelessWidget {
  final double amount;

  ListTileAmount({@required this.amount});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final _amountString =
        (normTwoDecimal(round((amount ?? 0.0), 2).toString()) == '0.00'
            ? '–'
            : normTwoDecimal(round((amount ?? 0.0), 2).toString()));
    final color = (_amountString == '–')
        ? Colors.black
        : ((amount < 0.0) ? Colors.red : Colors.lightGreen);
    final fontWeight =
        (_amountString == '–') ? FontWeight.normal : FontWeight.bold;
    return Container(
      height: 38,
      child: FittedBox(
        child: Text(
          _amountString,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontWeight: fontWeight),
        ),
        fit: BoxFit.scaleDown,
      ),
      width: screenWidth / 3,
    );
  }
}
