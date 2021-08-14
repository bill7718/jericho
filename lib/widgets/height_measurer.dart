import 'dart:async';

import 'package:flutter/material.dart';

///
/// Adds an [Offstage] widget to the tree.
///
/// This widget measures the height of the RichText widget that incorporates the list of [TextSpan]s and
/// reports in a callback.
///
class HeightMeasurer extends StatelessWidget {
  static const delay = Duration(milliseconds: 5);

  final double width;
  final List<TextSpan> spans;
  final Function heightCallback;

  const HeightMeasurer({Key? key, required this.width, required this.spans, required this.heightCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey _key = GlobalKey();

    Timer(delay, () {
      var box = _key.currentContext?.findRenderObject();
      if (box != null) {
        heightCallback((box as RenderBox).size.height);
      }
    });

    return Offstage(
        child: SizedBox(
            width: width,
            child: Card(
                child: RichText(
              key: _key,
              text: TextSpan(children: spans),
            ))));
  }
}
