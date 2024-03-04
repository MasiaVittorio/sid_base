import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';


class QuickField extends StatelessWidget {
  const QuickField({
    Key? key,
    required this.controller,
    required this.label,
    this.isDense,
    this.maxLines = 1,
    this.suffixIcon,
    this.onSubmitted,
    this.onEditingComplete,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.sentences,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final int? maxLines;
  final bool? isDense;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final void Function(String text)? onSubmitted;
  final void Function()? onEditingComplete;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        onTapOutside: (_) => context.unfocus(),
        decoration: InputDecoration(
          isDense: isDense,
          label: Text(label),
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
