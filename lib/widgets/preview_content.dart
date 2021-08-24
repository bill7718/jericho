
import 'package:flutter/material.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/widgets/rich_text_preview.dart';
import 'package:jericho/widgets/text_splitter.dart';
import 'package:provider/provider.dart';

class PreviewContent extends StatelessWidget {
  final List<TextSpan> spans;

  const PreviewContent({Key? key, required this.spans})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final splits = SpanSplit();

    return ChangeNotifierProvider<SpanSplit>.value(
        value: splits,
        child: Consumer<SpanSplit>(builder: (consumerContext, splits, _) {
          if (splits.split.isEmpty) {
            return TextSplitter(spans: spans, callback: splits.setSplits);
          } else {
            var widgets = <Widget>[];
            for (var range in splits.split) {
              var currentSpans = <TextSpan>[];
              currentSpans.addAll(spans.getRange(range.start, range.end));
              widgets.add(RichTextPreview(
                  spans: currentSpans,));
            }

            return GridView.count(crossAxisCount: 3,children: widgets);

          }
        }));
  }
}






