import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';
import 'package:flutter/material.dart' as mat;

extension BaseContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  EdgeInsets get safe => mediaQuery.padding;
  ScaffoldState get scaffold => Scaffold.of(this);
  NavigatorState get navigator => Navigator.of(this);

  T provide<T>() => CleanProvider.of<T>(this)!;

  void unfocus() {
    final FocusScopeNode currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
      currentScope.unfocus();
    }
  }

  Future<void> pushPage(Widget page) => navigator.push(MaterialPageRoute<void>(
        builder: (context) {
          return page;
        },
      ));
  Future<void> pushReplacementPage(Widget page) =>
      navigator.pushReplacement(MaterialPageRoute<void>(
        builder: (context) {
          return page;
        },
      ));
  Future<void> showDialog(Widget dialog) => mat.showDialog(
        context: this,
        builder: (_) => dialog,
      );
}
