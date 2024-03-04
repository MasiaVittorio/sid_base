import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

abstract class ValueEditView<T> extends StatefulWidget {
  const ValueEditView({
    required this.onSave,
    this.initial,
    super.key,
    this.resizeOnKeyboard = true,
  });

  final T? initial;
  final ValueChanged<T> onSave;
  final bool resizeOnKeyboard;
}

abstract class ValueEditViewState<T, A extends ValueEditView<T>> extends State<A> {
  T? get current;
  T? get initial => widget.initial;

  String get newTitle;
  String editTitle(T initialValue);

  Widget updateSaveButton(WidgetBuilder builder);
  // usually textreactor etc
  static Widget textReactor(
    BuildContext context,
    TextEditingController controller,
    WidgetBuilder builder,
  ) {
    return TextReactor(
      controller: controller,
      child: null,
      builder: (_, __, ___) => builder(context),
    );
  }

  Widget body(BuildContext context);

  bool get isCurrentEmpty => false;
  bool _isConfirmingPop = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isConfirmingPop ||
          _tryingToSaveNow ||
          current == initial ||
          initial == null && isCurrentEmpty,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          bool confirmPop = false;
          if (_isConfirmingPop || _tryingToSaveNow) {
            confirmPop = true;
          } else {
            try {
              final bool? response = await showDialog<bool>(
                context: context,
                builder: (context) {
                  // TODO: localize or provide edit capabilitini
                  return ConfirmDialog(
                    title: "Scarta modifiche?",
                    content: "Se esci ora, le modifiche non saranno salvate.",
                    confirmLabel: "Scarta ed esci",
                    dangerous: true,
                    action: () {},
                  );
                },
              );
              confirmPop = response ?? false;
            } catch (e) {
              confirmPop = false;
            }
          }
          if (confirmPop) {
            setState(() {
              _isConfirmingPop = true;
            });
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
        }
      },
      child: Scaffold(
        appBar: appBar,
        resizeToAvoidBottomInset: widget.resizeOnKeyboard,
        body: body(context),
      ),
    );
  }

  bool _tryingToSaveNow = false;
  VoidCallback? get getSaveAction {
    final c = current;
    if (c == null) return null;
    return () {
      widget.onSave(c);

      setState(() {
        _tryingToSaveNow = true;
      });
      // so it skips the onWillPop stuff that asks if you're sure you want to exit

      Navigator.of(context).maybePop();
    };
  }

  WidgetBuilder get saveButtonBuilder => (context) {
        final loc = MaterialLocalizations.of(context);
        return TextButton(
          onPressed: getSaveAction,
          child: Text(loc.saveButtonLabel),
        );
      };

  AppBar get appBar {
    final init = initial;
    return AppBar(
      title: Text(init == null ? newTitle : editTitle(init)),
      actions: [updateSaveButton(saveButtonBuilder)],
      leading: const CloseButton(),
    );
  }
}
