import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

typedef void DescriptionChangedCallback(String text);

class DescriptionTextField extends StatelessWidget {
  final DescriptionChangedCallback onChanged;
  final TextEditingController descriptionController;

  DescriptionTextField(
      {@required this.descriptionController, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(context).textTheme.body2,
      textCapitalization: TextCapitalization.words,
      controller: descriptionController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        filled: true,
        icon: Icon(Icons.info_outline),
        hintText: AppLocalizations.of(context).descriptionQuestion,
        labelText: AppLocalizations.of(context).description +
            ' (' +
            AppLocalizations.of(context).optional +
            ')',
      ),
      onChanged: onChanged,
      maxLength: 50,
    );
  }
}
