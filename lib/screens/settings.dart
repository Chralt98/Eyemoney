import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  // TODO: find the difference of stateless and stateful and why stateless necessary?
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(),
    );
  }
}
