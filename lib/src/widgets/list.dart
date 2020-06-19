import 'package:flutter/material.dart';

class EkfEmptyList extends StatelessWidget {
  EkfEmptyList({
    @required this.fab
  }) : assert(fab != null);

  final Widget fab;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text('Здесь пока никого нет =('),
          ),
          fab
        ],
      ),
    );
  }
}

class EkfStackList extends StatelessWidget {
  EkfStackList({
    @required this.fab,
    @required this.child
  }) : assert(fab != null && child != null);

  final Widget fab;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 20,
          right: 20,
          child: fab,
        )
      ],
    );
  }
}