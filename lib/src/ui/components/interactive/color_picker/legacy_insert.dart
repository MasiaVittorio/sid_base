import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LegacyInsertDialog extends StatefulWidget {
  const LegacyInsertDialog({
    super.key,
    required this.onConfirm,
    required this.hintText,
    required this.labelText,
    required this.inputType,
    required this.checker,
    required this.maxLenght,
    this.title = "",
    this.pasteChecker,
  });

  final String? Function(String)? pasteChecker;

  final String title;

  final String hintText;
  final String labelText;
  final void Function(String) onConfirm;
  final TextInputType inputType;

  /// checker has to return a string representing the error in an
  /// input. if it returns an empty string, there is no error
  final String Function(String) checker;
  final int maxLenght;

  @override
  State<LegacyInsertDialog> createState() => _InsertDialogState();
}

class _InsertDialogState extends State<LegacyInsertDialog> {
  TextEditingController? _controller;

  String? _clipboardString;

  bool? _pastable;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.hintText);

    _pastable = widget.pasteChecker != null;

    _clipboardString = null;
    _getClipboardAndCheck();
  }

  Future<void> _getClipboardAndCheck() async {
    final cbd = await Clipboard.getData("text/plain");
    setState(() {
      _clipboardString = _pasteChecker(cbd!.text);
    });
    return;
  }

  String? _pasteChecker(String? input) {
    if (input == null) return null;

    String? output;

    if (widget.pasteChecker == null) {
      output = input;
    } else {
      output = widget.pasteChecker!(input);
    }

    if (output == null) return null;

    return output.length > widget.maxLenght
        ? output.substring(0, widget.maxLenght)
        : output;
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String errorString = widget.checker(_controller!.text);
    bool error = errorString != '';

    final Color? themeTextColor = Theme.of(context).textTheme.bodyMedium?.color;

    final Widget expanded = TextField(
      keyboardType: widget.inputType,
      autofocus: true,
      textAlign: TextAlign.start,
      maxLength: widget.maxLenght,
      controller: _controller,
      textCapitalization: TextCapitalization.characters,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 18.0,
        fontWeight: error ? null : FontWeight.w600,
      ),
      onChanged: (String ts) => setState(() {}),
      decoration: InputDecoration(
        prefixText: "#FF ",
        prefixStyle: TextStyle(
          fontSize: 18.0,
          color: themeTextColor?.withValues(alpha: 0.5),
          fontWeight: FontWeight.w600,
        ),
        errorText: error ? errorString : null,
        // hintText: this.widget.hintText,
        labelText: widget.labelText,
      ),
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 24,
      title: Text(
        widget.title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: themeTextColor?.withValues(alpha: 0.7),
        ),
      ),
      content: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed:
                () => setState(() {
                  _controller!.clear();
                }),
          ),
          Expanded(child: expanded),
          IconButton(
            icon: Icon(
              Icons.content_paste,
              color:
                  _pastable!
                      ? _clipboardString != null
                          ? null
                          : IconTheme.of(context).color?.withValues(alpha: 0.5)
                      : Colors.transparent,
            ),
            onPressed:
                _pastable! && _clipboardString != null
                    ? () async {
                      await _getClipboardAndCheck();

                      if (_pastable == false) return;
                      if (_clipboardString == null) return;

                      setState(() {
                        _controller!.text = _clipboardString!;
                      });
                    }
                    : null,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          onPressed:
              error
                  ? null
                  : () {
                    if (widget.checker(_controller!.text) == '') {
                      Navigator.pop(context);
                      widget.onConfirm(_controller!.text);
                    }
                  },
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
