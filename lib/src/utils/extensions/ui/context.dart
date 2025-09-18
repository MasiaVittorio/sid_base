import 'package:flutter/material.dart' as mat;
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

extension BaseContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  EdgeInsets get safe => MediaQuery.paddingOf(this);
  ScaffoldState get scaffold => Scaffold.of(this);
  NavigatorState get navigator => Navigator.of(this);

  T provide<T>() => CleanProvider.of<T>(this)!;
  T? provideMaybe<T>() => CleanProvider.of<T>(this);

  void unfocus() {
    final FocusScopeNode currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
      currentScope.unfocus();
    }
  }

  Future<T?> pushPage<T>(Widget page) => navigator.push<T>(
    MaterialPageRoute<T>(
      builder: (context) {
        return page;
      },
    ),
  );
  Future<void> pushReplacementPage(Widget page) => navigator.pushReplacement(
    MaterialPageRoute<void>(
      builder: (context) {
        return page;
      },
    ),
  );
  Future<T?> showDialog<T>(Widget dialog) =>
      mat.showDialog<T>(context: this, builder: (_) => dialog);
}
