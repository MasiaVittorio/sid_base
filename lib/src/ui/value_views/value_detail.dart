import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

abstract class ValueDetail<T> extends StatelessWidget {

  const ValueDetail({
    super.key,
    this.cantEditNull = true,
  });

  final bool cantEditNull;

  void onSave(T newVal);

  Widget body(BuildContext context, T value);
  ValueEditView<T> editView(BuildContext context, T initial);
  String name(T value);
  List<PopupMenuEntry> menuItems(BuildContext context, T value);

  Widget updater(ValueBuilder<T> builder);

  Widget _builder(BuildContext context, T value) => Scaffold(
    appBar: appBar(context, value),
    body: body(context, value),
    floatingActionButton: showFabEdit 
      ? fab(value)
      : null,
  );

  bool get showFabEdit => true;

  @override
  Widget build(BuildContext context) {
    return updater(_builder);
  }

  Widget? fab(T dec) {
    if(dec == null && cantEditNull) return null;
    return OpenFab(
      margin: EdgeInsets.zero,
      extended: false, 
      label: const Text(""), 
      icon: const Icon(Icons.edit_outlined),
      openBuilder: (context, close) => editView(context, dec),
      useRootNavigator: useRootNavigatorForEdit,
    );
  }

  bool get useRootNavigatorForEdit => true;
  bool get showPopupMenuButton => true;

  AppBar appBar(BuildContext context, T value) {
    return AppBar(
      // leading: Icon(widget.icon),
      title: AnimatedText(name(value)),
      actions: (!showPopupMenuButton) ? null : [PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (_) => menuItems(context, value),
      )],
    );
  }
}

