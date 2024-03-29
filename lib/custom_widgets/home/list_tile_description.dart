import 'package:flutter/material.dart';

class ListTileDescription extends StatelessWidget {
  final String description;

  ListTileDescription({@required this.description});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Text(
        description ?? '–',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.body1,
      ),
    );
  }
}
