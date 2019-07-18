import 'package:flutter/material.dart';

class CrazySwitch extends StatefulWidget {
  _CrazySwitchState _crazySwitchState = new _CrazySwitchState();
  @override
  _CrazySwitchState createState() => _crazySwitchState;

  bool isChecked() {
    return _crazySwitchState.isChecked;
  }
}

class _CrazySwitchState extends State<CrazySwitch> with SingleTickerProviderStateMixin {
  bool isChecked = false;
  Duration _duration = Duration(milliseconds: 370);
  Animation<Alignment> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: _duration);

    _animation = AlignmentTween(begin: Alignment.centerLeft, end: Alignment.centerRight).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut, reverseCurve: Curves.bounceIn),
    );
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
          width: 80,
          height: 30,
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          decoration: BoxDecoration(
            color: isChecked ? Colors.lightGreen : Colors.red,
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: _animation.value,
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
