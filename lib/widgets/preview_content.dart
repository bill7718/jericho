import 'package:flutter/material.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/widgets/rich_text_preview.dart';
import 'package:jericho/widgets/text_splitter.dart';
import 'package:provider/provider.dart';

class PreviewContent extends StatelessWidget {
  final List<TextSpan> spans;
  final SpanSplit splits;

  const PreviewContent({Key? key, required this.spans, required this.splits})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SpanSplit>.value(
        value: splits,
        child: Container( margin: const EdgeInsetsDirectional.all(margin),
        child : Consumer<SpanSplit>(builder: (consumerContext, splits, _) {
          var widgets = <Widget>[];
          for (var range in splits.split) {
            var currentSpans = <TextSpan>[];
            currentSpans.addAll(spans.getRange(range.start, range.end));
            widgets.add(RichTextPreview(
              spans: currentSpans,
            ));
          }

          return GridView.count(crossAxisCount: 3, children: widgets, crossAxisSpacing: margin, mainAxisSpacing: margin,
          childAspectRatio: screenWidth / screenHeight,);
        })));
  }
}
