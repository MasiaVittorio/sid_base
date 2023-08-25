import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class InsertDialog extends StatefulWidget {
  const InsertDialog({
    Key? key,
    required this.title,
    required this.fieldLabel,
    required this.onInsert,
    this.confirmLabel = "Confirm",
    this.cancelLabel = "Cancel",
    this.initial,
  }) : super(key: key);

  final void Function(String) onInsert;
  final String? initial;
  final String fieldLabel;
  final String title;
  final String confirmLabel;
  final String cancelLabel;

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
      title: Text(widget.title),
      content: TextField(
        autofocus: true,
        controller: controller,
        decoration: InputDecoration(
          label: Text(widget.fieldLabel),
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
                : () async {
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
