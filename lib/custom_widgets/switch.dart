import 'package:flutter/material.dart';

class CrazySwitch extends StatefulWidget {
  bool isChecked;

  CrazySwitch({Key key, @required this.isChecked}) : super(key: key);

  @override
  _CrazySwitchState createState() => new _CrazySwitchState();

  bool getChecked() {
    return isChecked;
  }
}

class _CrazySwitchState extends State<CrazySwitch>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isChecked = !widget.isChecked;
        });
      },
      child: Container(
        width: 50,
        height: 30,
        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
        decoration: BoxDecoration(
          color: widget.getChecked() ? Colors.lightGreen : Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: widget.getChecked()
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
