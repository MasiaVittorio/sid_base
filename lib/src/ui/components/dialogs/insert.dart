import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class InsertDialog extends StatefulWidget {
  const InsertDialog({
    super.key,
    required this.title,
    required this.fieldLabel,
    this.fieldHint,
    required this.onInsert,
    this.confirmLabel = "Confirm",
    this.cancelLabel = "Cancel",
    this.initial,
    this.icon,
    this.maxLength,
    this.keyboardType,
  });

  final void Function(String) onInsert;
  final String? initial;
  final String fieldLabel;
  final String? fieldHint;
  final String title;
  final Widget? icon;
  final String confirmLabel;
  final String cancelLabel;
  final int? maxLength;
  final TextInputType? keyboardType;

  @override
  State<InsertDialog> createState() => _InsertDialogState();
}

class _InsertDialogState extends State<InsertDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: widget.icon,
      title: Text(widget.title),
      content: TextField(
        keyboardType: widget.keyboardType,
        autofocus: true,
        controller: controller,
        maxLength: widget.maxLength,
        onSubmitted: (value) {
          Navigator.pop(context);
          widget.onInsert(value);
        },
        decoration: InputDecoration(
          label: Text(widget.fieldLabel),
          hintText: widget.fieldHint,
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(
            widget.cancelLabel,
            style: TextStyle(
              color: context.theme.colorScheme.onSurface,
            ),
          ),
        ),
        TextReactor(
          controller: controller,
          child: Text(widget.confirmLabel),
          builder: (_, child, string) => TextButton(
            onPressed: string.isEmpty
                ? null
                : () {
                    final string = controller.text;
                    Navigator.pop(context);
                    widget.onInsert(string);
                  },
            child: child!,
          ),
        ),
      ],
    );
  }
}
