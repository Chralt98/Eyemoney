import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

typedef void SubmitCallback(String text);

class AmountTextField extends StatelessWidget {
  final MoneyMaskedTextController moneyController;
  final SubmitCallback submitCallback;

  AmountTextField(
      {@required this.moneyController, @required this.submitCallback});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.body2,
      controller: moneyController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        filled: true,
        icon: Icon(Icons.fiber_smart_record),
        labelText: AppLocalizations.of(context).amount +
            ' (' +
            AppLocalizations.of(context).optional +
            ')',
      ),
      onFieldSubmitted: submitCallback,
    );
  }
}
