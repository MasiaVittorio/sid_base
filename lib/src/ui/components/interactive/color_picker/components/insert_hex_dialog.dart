import 'package:flutter/material.dart';
import 'package:sid_base/src/ui/components/interactive/color_picker/legacy_insert.dart';

class InsertHexDialog extends StatelessWidget {
  final String startingString;
  final void Function(String) onConfirm;

  const InsertHexDialog({
    super.key,
    required this.startingString,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return LegacyInsertDialog(
      title: "Hex Color",
      hintText: startingString,
      onConfirm: onConfirm,
      maxLenght: 6,
      inputType: TextInputType.text,
      checker: (String s) => checkForHexString(s) == false ? "Error" : "",
      labelText: "",
      pasteChecker: _pasteChecker,
    );
  }

  String? _pasteChecker(String input) {
    if (input.length < 6) {
      input = input.padLeft(6, '0');
    } else if (input.length > 6) {
      input = input.substring(input.length - 6);
    }

    if (checkForHexString(input)) {
      return input;
    } else {
      return null;
    }
  }
}

bool checkForHexString(String input) {
  RegExp hexcolor = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

  bool errorFound = false;
  try {
    hexToColor(input);
  } catch (e) {
    errorFound = true;
  }
  if (errorFound == true) return false;

  return hexcolor.hasMatch(input);
}

/// Construct a color from a hex code string, of the format RRGGBB.
Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode.substring(0, 6), radix: 16) + 0xFF000000);
}
