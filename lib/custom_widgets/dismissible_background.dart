import 'package:flutter/material.dart';

class DismissibleBackground extends StatelessWidget {
  DismissibleBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Icon(Icons.delete),
      alignment: Alignment.centerRight,
    );
  }
}
