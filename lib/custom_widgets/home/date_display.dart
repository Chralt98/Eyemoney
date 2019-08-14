import 'package:flutter/material.dart';

class DateDisplay extends StatelessWidget {
  final DateTime date;

  DateDisplay({@required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text((date ?? DateTime.now()).month.toString() + ' - ' + (date ?? DateTime.now()).year.toString()),
      alignment: Alignment.centerRight,
    );
  }
}
