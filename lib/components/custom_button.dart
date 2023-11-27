import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.text = "",
    this.fontSize = 18,
    this.padding = 10,
    this.styleFormPadding = 20,
    this.backgroundColor = const Color(0xFF1B78C4),
    this.isIcon = false,
    this.isText = true,
    this.icon,
  });

  final void Function() onPressed;
  final String text;
  final double fontSize;
  final double padding;
  final double styleFormPadding;
  final Color? backgroundColor;
  final bool isIcon;
  final bool isText;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding:
            EdgeInsets.symmetric(vertical: 0, horizontal: styleFormPadding),
        backgroundColor: backgroundColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
          padding: EdgeInsets.all(padding),
          child: isText
              ? Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : isIcon
                  ? icon
                  : Container()),
    );
  }
}
