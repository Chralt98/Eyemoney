import 'package:Eyemoney/outsourcing/my_functions.dart';
import 'package:flutter/material.dart';

class ListTileAmount extends StatelessWidget {
  final double amount;

  ListTileAmount({@required this.amount});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 38,
      child: FittedBox(
        child: Text(
          normTwoDecimal(round((amount ?? 0.0), 2).toString()),
          textAlign: TextAlign.center,
          style: TextStyle(color: (amount < 0.0) ? Colors.red : Colors.lightGreen),
        ),
        fit: BoxFit.scaleDown,
      ),
      width: screenWidth / 3,
    );
  }
}
