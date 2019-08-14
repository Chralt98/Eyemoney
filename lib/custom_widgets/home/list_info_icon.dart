import 'package:flutter/material.dart';

class ListInfoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          this._getSymbol(context, Icons.info_outline),
          this._getSymbol(context, Icons.category),
          this._getSymbol(context, Icons.fiber_smart_record),
        ],
      ),
    );
  }

  Widget _getSymbol(BuildContext context, IconData symbol) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(width: 3, color: Colors.blueGrey),
          ),
          color: Colors.white),
      child: Container(
        child: Icon(symbol),
        width: screenWidth / 3,
      ),
    );
  }
}
