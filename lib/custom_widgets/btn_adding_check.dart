import 'package:flutter/material.dart';

class AddingCheck extends StatelessWidget {
  final VoidCallback onPressed;

  AddingCheck({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: Colors.blueAccent,
        onPressed: onPressed,
      ),
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.all(16),
    );
  }
}
