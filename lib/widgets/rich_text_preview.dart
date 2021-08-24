import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jericho/general/constants.dart';

class RichTextPreview extends StatelessWidget {
  final List<TextSpan> spans;

  const RichTextPreview({Key? key, required this.spans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var scale = constraints.maxWidth / screenWidth;
      scale = min(scale, constraints.maxHeight / screenHeight);

      var scaledSpans = <TextSpan>[];
      for (var span in spans) {
        scaledSpans.add(TextSpan(text: span.text, style: span.style?.copyWith(fontSize: (span.style?.fontSize ?? 0) * scale)));
      }


          return Container(
          width: scale * screenWidth,
          height: scale * screenHeight,
          padding: EdgeInsets.all(margin * scale),
          color: Colors.black,
          child: RichText(
            text: TextSpan(children: scaledSpans),
          ));
    });
  }
}
