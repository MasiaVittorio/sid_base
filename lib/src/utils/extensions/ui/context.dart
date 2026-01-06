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
  Future<T?> showModalBottomSheet<T>(
    Widget sheet, {

    Color? backgroundColor,
    String? barrierLabel,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    double scrollControlDisabledMaxHeightRatio =
        _defaultScrollControlDisabledMaxHeightRatio,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? showDragHandle,
    bool useSafeArea = false,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
    AnimationStyle? sheetAnimationStyle,
    bool? requestFocus,
  }) => mat.showModalBottomSheet<T>(
    context: this,
    builder: (_) => sheet,
    backgroundColor: backgroundColor,
    barrierLabel: barrierLabel,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    constraints: constraints,
    barrierColor: barrierColor,
    isScrollControlled: isScrollControlled,
    scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
    routeSettings: routeSettings,
    transitionAnimationController: transitionAnimationController,
    anchorPoint: anchorPoint,
    sheetAnimationStyle: sheetAnimationStyle,
    requestFocus: requestFocus,
  );

  static const double _defaultScrollControlDisabledMaxHeightRatio = 9.0 / 16.0;
}
