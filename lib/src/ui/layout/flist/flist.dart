// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:sid_base/sid_base.dart';
// import 'package:sid_base/src/ui/layout/flist/theme.dart';

// class FlistItem {
//   final ImageProvider background;
//   final Widget content;
//   const FlistItem({
//     required this.background,
//     required this.content,
//   });

//   static const example = FlistItem(
//     background: AssetImage("assets/example.png"),
//     content: Pad(all: 8, child: Placeholder()),
//   );
// }

// class Flist extends StatefulWidget {
//   const Flist({
//     super.key,
//     required this.items,
//     required this.axis,
//     this.theme,
//   });

//   final List<FlistItem> items;
//   final Axis axis;
//   final FlistTheme? theme;

//   @override
//   State<Flist> createState() => _FlistState();
// }


// class _FlistState extends State<Flist> {
//   late final ScrollController controller = ScrollController();
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final FlistTheme theme = widget.theme ?? CleanProvider.of(context) ?? const FlistTheme();

//     return CleanProvider(
//       data: theme,
//       child: LayoutBuilder(builder: (context, constraints) {
//         return ConstrainedBox(
//           constraints: constraints,
//           child: _FlistBody(
//             controller: controller,
//             items: widget.items,
//             axis: widget.axis,
//             mainAxisSize: widget.axis.fold(
//               ifVertifcal: () => constraints.maxHeight,
//               ifHorizontal: () => constraints.maxWidth,
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// class _FlistBody extends StatelessWidget {
//   const _FlistBody({
//     super.key,
//     required this.items,
//     required this.axis,
//     required this.mainAxisSize,
//     required this.controller,
//   });

//   final List<FlistItem> items;
//   final Axis axis;
//   final double mainAxisSize;
//   final ScrollController controller;

//   @override
//   Widget build(BuildContext context) {
//     final theme = context.provide<FlistTheme>();
//     return ListView.builder(
//       scrollDirection: axis,
//       controller: controller,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         return const Placeholder(
//           fallbackHeight: 50,
//           fallbackWidth: 50,
//         );
//       },
//       itemCount: items.length,
//       // physics: PageScrollPhysics(),
//     );
//   }
// }
