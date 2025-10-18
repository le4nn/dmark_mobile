import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Информационный диалог
class CustomInfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final String buttonText;

  const CustomInfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
    this.buttonText = 'OK',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      icon: icon != null
          ? Icon(
        icon,
        size: 32,
        color: iconColor ?? theme.colorScheme.primary,
      )
          : null,
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(buttonText),
        ),
      ],
    );
  }
}