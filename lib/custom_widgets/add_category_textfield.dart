import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

typedef void TextFieldChangedCallback(String text);

class AddCategoryTextField extends StatelessWidget {
  final TextFieldChangedCallback onChanged;
  final TextFieldChangedCallback onSubmitted;
  final TextEditingController addCategoryController;

  AddCategoryTextField({@required this.onChanged, @required this.onSubmitted, @required this.addCategoryController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        textCapitalization: TextCapitalization.words,
        controller: addCategoryController,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          icon: Icon(Icons.category),
          hintText: AppLocalizations.of(context).addCategoryDescription,
          labelText: AppLocalizations.of(context).addCategory,
        ),
        onChanged: (String text) => onChanged(text),
        onSubmitted: (String category) => onSubmitted(category),
        keyboardType: TextInputType.text,
        maxLength: 25,
      ),
    );
  }
}
