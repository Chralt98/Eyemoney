import 'package:flutter/material.dart';

typedef SubmitCallback(String text);
typedef ChangedCallback(String text);

class QuantityTextField extends StatelessWidget {
  final TextEditingController quantityController;
  final SubmitCallback onSubmitQuantity;
  final ChangedCallback onChanged;

  QuantityTextField({@required this.quantityController, @required this.onSubmitQuantity, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      child: TextField(
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
        onTap: () => quantityController.text = '',
        onChanged: onChanged,
        onSubmitted: onSubmitQuantity,
        controller: quantityController,
      ),
    );
  }
}
