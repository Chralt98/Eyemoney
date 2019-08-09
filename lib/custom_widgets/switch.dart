import 'package:flutter/material.dart';

class CrazySwitch extends StatefulWidget {
  bool isChecked;
  _CrazySwitchState _crazySwitchState = new _CrazySwitchState();

  CrazySwitch({Key key, @required this.isChecked}) : super(key: key);

  @override
  _CrazySwitchState createState() => _crazySwitchState;

  bool getChecked() {
    return isChecked;
  }

  void switchMode(bool mode) {
    // TODO: Fix bug, that the dismissible always have to delete the edit record because when leaving the screen everything should be as the beginning
    // TODO: Fix bug that isChecked runs on false when the state is initially called
    isChecked = mode;
  }
}

class _CrazySwitchState extends State<CrazySwitch>
    with SingleTickerProviderStateMixin {
  // bool isChecked = false;
  Duration _duration = Duration(milliseconds: 370);
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _duration);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: 50,
          height: 30,
          padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
          decoration: BoxDecoration(
            color: (widget.isChecked ?? false) ? Colors.lightGreen : Colors.red,
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: (widget.isChecked ?? false)
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_animationController.isCompleted) {
                        _animationController.reverse();
                      } else {
                        _animationController.forward();
                      }
                      widget.switchMode(!(widget.isChecked ?? true));
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
