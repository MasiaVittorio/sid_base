import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

enum ConfirmButtonType {
  text,
  outlined,
  filled,
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.action,
    this.content,
    this.customContent,
    this.confirmIcon,
    this.confirmLabel,
    this.customCancelLabel,
    this.icon,
    this.dangerous = false,
    this.confirmButtonType = ConfirmButtonType.filled,
  });

  final String title;
  final String? content;
  final Widget? customContent;
  final IconData? icon;
  final bool dangerous;
  final IconData? confirmIcon;
  final String? confirmLabel;
  final String? customCancelLabel;
  final VoidCallback action;
  final ConfirmButtonType confirmButtonType;

  @override
  Widget build(BuildContext context) {
    final content = this.content;

    final locs = MaterialLocalizations.of(context);

    final cancelText = Text(customCancelLabel ?? locs.cancelButtonLabel);

    final confirmText = Text(confirmLabel ?? locs.okButtonLabel);

    void cancelAction() {
      Navigator.of(context).pop(false);
    }

    void confirmAction() {
      Navigator.of(context).pop(true);
      action();
    }

    final icon = this.icon;

    final theme = context.theme;
    final cancelStyle = ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(theme.colorScheme.onSurface),
    );
    final Color? filledBackground = dangerous ? theme.colorScheme.error : null;
    final Color? filledForeground = dangerous ? theme.colorScheme.onError : null;
    final Color? textForeground = dangerous ? theme.colorScheme.error : null;
    final filledConfirmStyle = ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(filledBackground),
      foregroundColor: MaterialStatePropertyAll(filledForeground),
      iconColor: MaterialStatePropertyAll(filledForeground),
    );
    final textConfirmStyle = ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(textForeground),
      iconColor: MaterialStatePropertyAll(textForeground),
      side: switch(confirmButtonType){
        ConfirmButtonType.outlined => MaterialStatePropertyAll(BorderSide(color: textForeground ?? theme.colorScheme.primary)),
        _ => null,
      }
    );

    return AlertDialog(
      title: Text(title),
      icon: icon == null ? null : Icon(icon),
      content:customContent ?? (content == null ? null : Text(content)),
      actions: [
        if (confirmIcon != null)
          TextButton.icon(
            onPressed: cancelAction,
            icon: const Icon(Icons.close),
            label: cancelText,
            style: cancelStyle,
          )
        else
          TextButton(
            onPressed: cancelAction,
            style: cancelStyle,
            child: cancelText,
          ),
        switch (confirmButtonType) {
          ConfirmButtonType.filled => filledConfirmButton(
              confirmStyle: filledConfirmStyle,
              confirmAction: confirmAction,
              confirmText: confirmText,
            ),
          ConfirmButtonType.outlined => outlineConfirmButton(
              confirmStyle: textConfirmStyle,
              confirmAction: confirmAction,
              confirmText: confirmText,
            ),
          ConfirmButtonType.text => textConfirmButton(
              confirmStyle: textConfirmStyle,
              confirmAction: confirmAction,
              confirmText: confirmText,
            ),
        }
      ],
    );
  }

  Widget filledConfirmButton({
    required ButtonStyle confirmStyle,
    required VoidCallback confirmAction,
    required Widget confirmText,
  }) {
    if (confirmIcon case IconData confirmIcon) {
      return FilledButton.icon(
        onPressed: confirmAction,
        icon: Icon(confirmIcon),
        label: confirmText,
        style: confirmStyle,
      );
    } else {
      return FilledButton(
        onPressed: confirmAction,
        style: confirmStyle,
        child: confirmText,
      );
    }
  }

  Widget textConfirmButton({
    required ButtonStyle confirmStyle,
    required VoidCallback confirmAction,
    required Widget confirmText,
  }) {
    if (confirmIcon case IconData confirmIcon) {
      return TextButton.icon(
        onPressed: confirmAction,
        icon: Icon(confirmIcon),
        label: confirmText,
        style: confirmStyle,
      );
    } else {
      return TextButton(
        onPressed: confirmAction,
        style: confirmStyle,
        child: confirmText,
      );
    }
  }

  Widget outlineConfirmButton({
    required ButtonStyle confirmStyle,
    required VoidCallback confirmAction,
    required Widget confirmText,
  }) {
    if (confirmIcon case IconData confirmIcon) {
      return OutlinedButton.icon(
        onPressed: confirmAction,
        icon: Icon(confirmIcon),
        label: confirmText,
        style: confirmStyle,
      );
    } else {
      return OutlinedButton(
        onPressed: confirmAction,
        style: confirmStyle,
        child: confirmText,
      );
    }
  }
}
