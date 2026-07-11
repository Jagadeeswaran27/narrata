import 'package:flutter/material.dart';

class AuthPrompt extends StatelessWidget {
  final String promptText;
  final String buttonText;
  final VoidCallback onPressed;

  const AuthPrompt({
    super.key,
    required this.promptText,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(promptText, style: TextStyle(color: colorScheme.onSurfaceVariant)),
        TextButton(onPressed: onPressed, child: Text(buttonText)),
      ],
    );
  }
}
