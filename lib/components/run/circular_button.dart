import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.child,
  });

  final void Function() onPressed;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(109, 109),
          backgroundColor: color,
          shape: CircleBorder(),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
