import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PaletteColorPicker extends StatefulWidget {
  final Color? color;
  final Function(Color?) onChanged;
  final void Function()? paletteUndescrollCallback;
  final Color? backgroundColor;

  const PaletteColorPicker({
    super.key,
    required this.color,
    required this.onChanged,
    this.paletteUndescrollCallback,
    this.backgroundColor,
  });

  @override
  State createState() => _PaletteColorPickerState();
}

class _PaletteColorPickerState extends State<PaletteColorPicker>
    with TickerProviderStateMixin {
  final List<PaletteTab> _tabs = PaletteTab.allTabs;

  TabController? _tabController;

  int? _colorIndex;

  List<int?> find(Color? c) {
    for (int tabI = 0; tabI < _tabs.length; ++tabI) {
      final tab = _tabs[tabI];
      for (int colI = 0; colI < tab.shades.length; ++colI) {
        if (tab.shades[colI] == c) {
          return [tabI, colI];
        }
      }
    }
    return <int?>[null, null];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    List<int?> indexes = find(widget.color);
    _tabController!.index =
        indexes[0] ?? PaletteTab.findClosestTabIndex(_tabs, widget.color) ?? 0;
    _colorIndex = indexes[1];

    /// NOT REALLY SURE WHY IT WAS NEEDED, ON  TAP SHOULD TAKE CARE OF THIS
    // this._tabController.addListener((){
    //   this._secondIndex = this._thisColors[this._tabController.index].defaultIndex;
    //   widget.onChanged(this.currentColor);
    // });
    /// NOT REALLY SURE WHY IT WAS NEEDED, ON  TAP SHOULD TAKE CARE OF THIS
  }

  @override
  void didUpdateWidget(PaletteColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      List<int?> indexes = find(widget.color);
      _tabController!.index =
          indexes[0] ??
          PaletteTab.findClosestTabIndex(_tabs, widget.color) ??
          0;
      _colorIndex = indexes[1];
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Color? get currentColor =>
      _colorIndex == null
          ? null
          : _tabs[_tabController!.index].shades[_colorIndex!];

  @override
  Widget build(BuildContext context) {
    final Widget row = Material(
      color: widget.backgroundColor,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 64),
        child: TabBar(
          onTap:
              (int i) => setState(() {
                _colorIndex = _tabs[i].defaultIndex;
                widget.onChanged(currentColor);
              }),
          isScrollable: true,
          dragStartBehavior: DragStartBehavior.down,
          indicatorColor: Theme.of(context).textTheme.bodyMedium?.color,
          indicatorWeight: 3.0,
          tabs: List.generate(_tabs.length, (int i) {
            return Tab(
              text: _tabs[i].name,
              icon: Icon(MdiIcons.circle, color: _tabs[i].defaultColor),
            );
          }),
          controller: _tabController,
          unselectedLabelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          labelColor: Theme.of(context).textTheme.bodyMedium?.color,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelColor: Theme.of(
            context,
          ).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
        ),
      ),
    );

    final theme = Theme.of(context);
    final Widget column = Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.white),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return ConstrainedBox(
            constraints: constraints,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                for (int tabI = 0; tabI < _tabs.length; ++tabI)
                  ListView(
                    physics: CallbackScrollPhysics(
                      alwaysScrollable: true,
                      bottomBounce: false,
                      topBounce: widget.paletteUndescrollCallback != null,
                      topBounceCallback: widget.paletteUndescrollCallback,
                    ),
                    children: <Widget>[
                      for (final couple in <Widget>[
                        for (
                          int colorI = 0;
                          colorI < _tabs[tabI].shades.length;
                          ++colorI
                        )
                          _buildTile(
                            colorIndex: colorI,
                            color: _tabs[tabI].shades[colorI],
                            len: _tabs[tabI].shades.length,
                            maxH: constraints.maxHeight,
                            minH: 58,
                          ),
                      ].part(2))
                        Row(
                          children: [
                            for (final child in couple) Expanded(child: child),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );

    const Widget divider = Divider(height: 0.0);

    return Column(children: <Widget>[Expanded(child: column), divider, row]);
  }

  Widget _buildTile({
    required int colorIndex,
    required Color color,
    required int len,
    required double minH,
    required double maxH,
  }) {
    int rows = (len / 2).ceil();
    double height = math.max(minH, maxH / rows);

    final bool check = currentColor == color;
    final Color text = color.contrast;

    return Material(
      color: color,
      child: InkWell(
        onTap: () {
          setState(() {
            _colorIndex = colorIndex;
            widget.onChanged(currentColor);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "#FF${color.hexString}",
                style: TextStyle(fontWeight: FontWeight.w700, color: text),
              ),
              // TODO: nonsense, la prima volta che viene trovato il closest qua non mostra il selezionato
              Icon(Icons.check, color: check ? text : Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }
}
