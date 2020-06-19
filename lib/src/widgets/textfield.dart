import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EkfTextField extends StatelessWidget{
  const EkfTextField({
    this.maxLength = 30,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.focusNode,
    this.nextFocusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.onSaved,
    this.initialValue,
    this.items,
  });

  final int maxLength;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final TextInputAction textInputAction;
  final void Function() onFieldSubmitted;
  final Function(String) onChanged;
  final Function(String) onSaved;
  final String initialValue;
  final int maxLines;
  final TextInputType keyboardType;
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
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      onFieldSubmitted: (_) => onFieldSubmitted == null
        ? FocusScope.of(context).nextFocus()
        : onFieldSubmitted(),
      textInputAction: textInputAction,
      focusNode: focusNode,
      maxLength: maxLength,
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