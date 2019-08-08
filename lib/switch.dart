import 'package:flutter/material.dart';

class CrazySwitch extends StatefulWidget {
  _CrazySwitchState _crazySwitchState = new _CrazySwitchState();

  @override
  _CrazySwitchState createState() => _crazySwitchState;

  bool isChecked() {
    return _crazySwitchState.isChecked;
  }

  void switchMode(bool mode) {
    // TODO: Fix bug, that the dismissible always have to delete the edit record because when leaving the screen everything should be as the beginning
    // TODO: Fix bug that isChecked runs on false when the state is initially called
    _crazySwitchState.isChecked = mode;
  }
}

class _CrazySwitchState extends State<CrazySwitch>
    with SingleTickerProviderStateMixin {
  bool isChecked = false;
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
            color: isChecked ? Colors.lightGreen : Colors.red,
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment:
                    isChecked ? Alignment.centerRight : Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_animationController.isCompleted) {
                        _animationController.reverse();
                      } else {
                        _animationController.forward();
                      }

                      isChecked = !isChecked;
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
