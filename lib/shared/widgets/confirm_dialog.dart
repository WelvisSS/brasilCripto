import 'package:flutter/material.dart';

import '../../res/colors/colors.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.cancelLabel = 'Cancelar',
    this.confirmLabel = 'Remover',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(color: AppColors.gray, fontSize: 16),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            cancelLabel,
            style: const TextStyle(
              color: AppColors.gray,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text(
            confirmLabel,
            style: const TextStyle(
              color: AppColors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
