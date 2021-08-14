import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/widgets/simple_grid_view.dart';

import 'package:provider/provider.dart';

import 'height_measurer.dart';

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
              widgets.add(Container(
                  width: previewScale * screenWidth,
                  height: previewScale * screenHeight,
                  padding: const EdgeInsets.all(margin * previewScale),
                  color: Colors.black,
                  child: RichText(
                    text: TextSpan(children: currentSpans),
                    textScaleFactor: previewScale,
                  )));
            }

            //return GridView.count(crossAxisCount: 3,children: widgets);


            return SimpleGridView(
              children: widgets,
              numberOfColumns: 3,
              spacing: const EdgeInsets.all(5),
            );


          }
        }));
  }
}

class SpanSplit extends ChangeNotifier {
  final List<SpanRange> _split = <SpanRange>[];

  setSplits(List<SpanRange> s) {
    _split.clear();
    _split.addAll(s);
    notifyListeners();
  }

  List<SpanRange> get split => _split;
}

class TextSplitter extends StatefulWidget {
  static const double defaultWidth = screenWidth - 2 * margin;
  static const double defaultHeight = screenHeight - 2 * margin;

  final double width;
  final List<TextSpan> spans;
  final double maxHeight;

  final Function callback;

  const TextSplitter(
      {Key? key,
      this.width = defaultWidth,
      this.maxHeight = defaultHeight,
      required this.spans,
      required this.callback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextSplitterState();
}

class _TextSplitterState extends State<TextSplitter> {
  static const int maxAttemptCount = 999;

  List<SpanRange> separators = <SpanRange>[];
  int rangeStart = 0;
  int rangeEnd = 0;

  int attemptCount = 0;

  @override
  void initState() {
    super.initState();

    if (widget.spans.first.text == '\n\n') {
      rangeStart = 1;
    }

    rangeEnd = widget.spans.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    attemptCount++;
    var spansToMeasure = <TextSpan>[];
    spansToMeasure.addAll(widget.spans.getRange(rangeStart, rangeEnd));
    return HeightMeasurer(width: widget.width, spans: spansToMeasure, heightCallback: heightCallback);
  }

  void heightCallback(double height) {
    if (height > widget.maxHeight) {
      setState(() {
        rangeEnd--;
      });
    } else {
      separators.add(SpanRange(rangeStart, rangeEnd));
      rangeStart = rangeEnd;

      rangeEnd = widget.spans.length;
      if (rangeStart == rangeEnd || attemptCount > maxAttemptCount) {
        widget.callback(
          separators,
        );
      } else {
        if (widget.spans[rangeStart].text == '\n\n') {
          rangeStart++;
        }
        setState(() {});
      }
    }
  }
}

class SpanRange {
  final int start;
  final int end;

  SpanRange(this.start, this.end);
}


