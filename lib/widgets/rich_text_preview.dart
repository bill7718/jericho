
import 'package:flutter/material.dart';
import 'package:jericho/general/constants.dart';

class RichTextPreview extends StatelessWidget {

  final List<TextSpan> spans;

  const RichTextPreview({ Key? key, required this.spans}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        width: previewScale * screenWidth,
        height: previewScale * screenHeight,
        padding: const EdgeInsets.all(margin * previewScale),
        color: Colors.black,
        child: RichText(
          text: TextSpan(children: spans),
          textScaleFactor: previewScale,
        ));
  }



}