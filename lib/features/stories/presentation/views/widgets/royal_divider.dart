import 'package:flutter/material.dart';

class RoyalDivider extends StatelessWidget {
  final Color color;
  final double width;

  const RoyalDivider({
    super.key, 
    this.color = const Color(0xFF8B5A2B), 
    this.width = 240,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Image.asset(
        'assets/images/divider_trimmed.png',
        fit: BoxFit.fitWidth,
        color: color, // Optional: apply color tint if it's a transparent PNG
      ),
    );
  }
}
