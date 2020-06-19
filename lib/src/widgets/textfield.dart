import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EkfTextField extends StatelessWidget{
  const EkfTextField({
    this.onChanged,
    this.onSaved,
    this.initialValue,
    this.items,
  });

  final Function(String) onChanged;
  final Function(String) onSaved;
  final String initialValue;
  ///items != null ? dropdownfield : textfield
  final List<DropdownMenuItem<String>> items;

  @override
  Widget build(BuildContext context){

    return items != null
      ? _dropdown()
      : _textfield(context);
  }

  Widget _dropdown(){
    return DropdownButtonFormField(
      items: items,
      value: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        counterText: '',
        errorStyle: TextStyle(height: 0),
      ),
      validator: (String value) {
        if (value == null) {
          return '';
        }
        return null;
      },
    );
  }

  Widget _textfield(BuildContext context){
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        counterText: '',
        errorStyle: TextStyle(height: 0),
      ),
      maxLines: 1,
      textCapitalization: TextCapitalization.sentences,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      textInputAction: TextInputAction.next,
      maxLength: 30,
      validator: (String value) {
        if (value.trim().isEmpty) {
          return '';
        }
        return null;
      },
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
}