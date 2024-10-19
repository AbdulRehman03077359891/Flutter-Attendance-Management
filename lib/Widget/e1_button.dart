import 'package:flutter/material.dart';

class E1Button extends StatelessWidget {
  final Color backColor;
  final Color textColor;
  final String text;
  final double size;
  final VoidCallback? onPressed;
  final Color? shadowColor;
  final double elevation;
  final Color? disabledBackgroundColor;

  const E1Button({
    super.key,
    required this.backColor,
    required this.text,
    required this.textColor,
    this.onPressed,
    this.shadowColor,
    this.size = 16.0, // Default font size
    this.elevation = 10.0, 
    this.disabledBackgroundColor, // Default elevation
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(disabledBackgroundColor: disabledBackgroundColor,
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: backColor,
        shadowColor: shadowColor,
        elevation: elevation,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: size,
            shadows: const [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 5,
                  spreadRadius: 5,
                )
              ]
          ),
        ),
      ),
    );
  }
}
