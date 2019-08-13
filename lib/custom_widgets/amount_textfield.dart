import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

typedef String ValidatorCallback(String text);
typedef void SubmitCallback(String text);

class AmountTextField extends StatelessWidget {
  final MoneyMaskedTextController moneyController;
  final ValidatorCallback validatorCallback;
  final SubmitCallback submitCallback;

  AmountTextField({@required this.moneyController, @required this.validatorCallback, @required this.submitCallback});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: moneyController,
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        filled: true,
        icon: Icon(Icons.fiber_smart_record),
        labelText: AppLocalizations.of(context).amount,
      ),
      validator: validatorCallback,
      onFieldSubmitted: submitCallback,
      // onChanged: (String number) => this._amount = number,
    );
  }
}
