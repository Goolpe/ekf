import 'package:flutter/material.dart';

class EkfFormField extends StatelessWidget {
  EkfFormField({
    @required this.label,
    @required this.child
  }) : assert(child != null && label != null);

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(label)
        ),
        Expanded(
          flex: 2,
          child: child,
        )
      ],
    );
  }
}