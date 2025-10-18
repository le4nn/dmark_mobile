import 'package:flutter/material.dart';

import '../../constants/breakpoints.dart';
import 'custom_dialog.dart';
import 'info_dialog.dart';

/// Вспомогательные функции для показа диалогов
class DialogHelper {
  /// Показать диалог подтверждения
  static Future<bool> showConfirmDialog(
      BuildContext context, {
        required String title,
        required String message,
        IconData? icon,
        Color? iconColor,
        String confirmText = 'Подтвердить',
        String cancelText = 'Отмена',
        bool isDangerous = false,
      }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => CustomConfirmDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
        confirmText: confirmText,
        cancelText: cancelText,
        isDangerous: isDangerous,
      ),
    );
    return result ?? false;
  }

  /// Показать информационный диалог
  static Future<void> showInfoDialog(
      BuildContext context, {
        required String title,
        required String message,
        IconData? icon,
        Color? iconColor,
        String buttonText = 'OK',
      }) async {
    await showDialog(
      context: context,
      builder: (context) => CustomInfoDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
        buttonText: buttonText,
      ),
    );
  }

  /// Показать SnackBar с успехом
  static void showSuccessSnackBar(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: Breakpoints.paddingM),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Breakpoints.borderRadiusM),
        ),
      ),
    );
  }

  /// Показать SnackBar с ошибкой
  static void showErrorSnackBar(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(width: Breakpoints.paddingM),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Breakpoints.borderRadiusM),
        ),
      ),
    );
  }
}