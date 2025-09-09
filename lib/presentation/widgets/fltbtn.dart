import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback pressEvent;

  const CustomFloatingButton({super.key, required this.pressEvent});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: pressEvent,
      backgroundColor: Colors.orange[300],
      child: const Icon(Icons.arrow_upward),
    );
  }
}
