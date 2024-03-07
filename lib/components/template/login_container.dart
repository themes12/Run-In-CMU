import 'package:flutter/material.dart';

class LoginContainer extends StatelessWidget {
  const LoginContainer({
    super.key,
    required this.child,
    this.padding = true,
  });
  final Widget child;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: padding
          ? Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: child,
      )
          : child,
    );
  }
}
