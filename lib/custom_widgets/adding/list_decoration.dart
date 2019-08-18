import 'package:flutter/material.dart';

class ListDecoration extends StatelessWidget {
  final int index;
  final Widget tile;

  ListDecoration({@required this.index, @required this.tile});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: tile,
      decoration: BoxDecoration(
        color: (index % 2 == 0)
            ? Color.fromARGB(5, 255, 255, 0)
            : Color.fromARGB(5, 0, 0, 255),
        border: Border.fromBorderSide(
          BorderSide(
              width: 0.0, color: Colors.black12, style: BorderStyle.solid),
        ),
      ),
    );
  }
}
