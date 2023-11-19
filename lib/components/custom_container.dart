import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.child,
    required this.outerPadding,
    required this.innerPadding,
    required this.containerColor,
  });

  final Widget child;
  final EdgeInsetsGeometry outerPadding;
  final EdgeInsetsGeometry innerPadding;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: outerPadding,
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(20),
        color: containerColor,
        elevation: 18,
        shadowColor: const Color(0xFF000000),
        child: Padding(
          padding: innerPadding,
          child: child,
        ),
      ),
    );
  }
}
