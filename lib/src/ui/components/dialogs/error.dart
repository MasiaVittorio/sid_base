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
