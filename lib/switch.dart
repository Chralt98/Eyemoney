import 'package:flutter/material.dart';

class CrazySwitch extends StatefulWidget {
  @override
  _CrazySwitchState createState() => _CrazySwitchState();
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

  // only for communicate the status of toggle for revenue or not
  bool isGreen() {
    return this.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: 50,
          height: 20,
          padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
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
                    width: 20,
                    height: 20,
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
