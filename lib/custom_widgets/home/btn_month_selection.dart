import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  final VoidCallback onPressed;

  MonthSelector({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.date_range),
      onPressed: onPressed,
    );
  }
}
