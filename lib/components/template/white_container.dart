/// Written by Thiti Phuttaamart 640510660
import 'package:flutter/material.dart';

class WhiteContainer extends StatelessWidget {
  const WhiteContainer({
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
      height: double.infinity,
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
