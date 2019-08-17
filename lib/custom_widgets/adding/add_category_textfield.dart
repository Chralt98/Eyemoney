import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

typedef void TextFieldChangedCallback(String text);

class AddCategoryTextField extends StatelessWidget {
  final TextFieldChangedCallback onSubmitted;
  final TextEditingController addCategoryController;

  AddCategoryTextField(
      {@required this.onSubmitted, @required this.addCategoryController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(end: 40),
      child: TextField(
        style: Theme.of(context).textTheme.body2,
        textCapitalization: TextCapitalization.words,
        controller: addCategoryController,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          icon: Icon(Icons.category),
          hintText: AppLocalizations.of(context).addCategoryDescription,
          labelText: AppLocalizations.of(context).addCategory,
        ),
        onSubmitted: (String category) => onSubmitted(category),
        keyboardType: TextInputType.text,
        maxLength: 25,
      ),
    );
  }
}
