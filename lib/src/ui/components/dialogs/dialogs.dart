// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {

  const ErrorDialog({
    required this.title,
    required this.content,
    super.key,
  });
  
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.error),
      title: Text(title),
      content: Text(content),
      actions: [TextButton(
        onPressed: Navigator.of(context).pop, 
        child: const Text("Ok"),
      )],
    );
  }
}

class ConfirmDialog extends StatelessWidget {

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.action,
    this.content,
    this.confirmColor,
    this.confirmIcon,
    this.confirmLabel,
    this.icon,
  });

  final String title;
  final String? content;
  final IconData? icon;
  final Color? confirmColor;
  final IconData? confirmIcon;
  final String? confirmLabel;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    final content = this.content;

    const cancelText = Text("Cancel");

    final confirmIcon = this.confirmIcon;
    final confirmText = Text(
      confirmLabel ?? "Ok", 
      style: TextStyle(color: confirmColor),
    );

    void cancelAction() {
      Navigator.of(context).pop(false);
    }
    void confirmAction() {
      Navigator.of(context).pop(true);
      action();
    }

    final icon = this.icon;

    return AlertDialog(
      title: Text(title),
      icon: icon == null ? null : Icon(icon),
      content: content == null ? null : Text(content),
      actions: [
        if(confirmIcon != null) TextButton.icon(
          onPressed: cancelAction, 
          icon: const Icon(Icons.close),
          label: cancelText,
        )
        else TextButton(
          onPressed: cancelAction, 
          child: cancelText,
        ),

        if(confirmIcon != null) TextButton.icon(
          onPressed: confirmAction,
          icon: Icon(confirmIcon, color: confirmColor),
          label: confirmText,
        )
        else TextButton(
          onPressed: confirmAction,
          child: confirmText,
        )
      ],
    );
  }
}