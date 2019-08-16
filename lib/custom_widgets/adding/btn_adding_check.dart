import 'package:flutter/material.dart';

class AddingCheck extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isVisible;

  AddingCheck({@required this.onPressed, @required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Visibility(
        visible: isVisible,
        child: FloatingActionButton(
          child: Icon(Icons.check),
          backgroundColor: Theme.of(context).accentColor,
          onPressed: onPressed,
        ),
      ),
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.all(16),
    );
  }
}
