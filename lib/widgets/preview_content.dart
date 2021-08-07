import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/constants.dart';

import 'package:provider/provider.dart';

class PreviewContent extends StatelessWidget {
  final List<TextSpan> spans;

  PreviewContent({Key? key, required this.spans})
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
                  padding: EdgeInsets.all(margin * previewScale),
                  color: Colors.black,
                  child: RichText(
                    text: TextSpan(children: currentSpans),
                    textScaleFactor: previewScale,
                  )));
            }

            return SimpleGridView(
              children: widgets,
              numberOfColumns: 3,
              spacing: EdgeInsets.all(5),
            );
          }
        }));
  }
}

class SpanSplit extends ChangeNotifier {
  List<SpanRange> _split = <SpanRange>[];

  setSplits(List<SpanRange> s) {
    _split.clear();
    _split.addAll(s);
    notifyListeners();
  }

  List<SpanRange> get split => _split;
}

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

  HeightMeasurer({Key? key, required this.width, required this.spans, required this.heightCallback}) : super(key: key);

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
        child: Container(
            width: width,
            child: Card(
                child: RichText(
              key: _key,
              text: TextSpan(children: spans),
            ))));
  }
}

class TextSplitter extends StatefulWidget {
  static const double defaultWidth = screenWidth - 2 * margin;
  static const double defaultHeight = screenHeight - 2 * margin;

  final double width;
  final List<TextSpan> spans;
  final double maxHeight;

  final Function callback;

  TextSplitter(
      {this.width = defaultWidth, this.maxHeight = defaultHeight, required this.spans, required this.callback});

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

class SimpleGridView extends StatelessWidget {
  final List<Widget> children;
  final int numberOfColumns;
  final EdgeInsets spacing;

  SimpleGridView({required this.children, this.numberOfColumns = 3, this.spacing = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    var rows = <Widget>[];
    var rowContents = <Widget>[];
    rowContents.add(
      Container(
        margin: spacing,
      ),
    );
    for (var item in children) {
      rowContents.add(item);
      rowContents.add(
        Container(
          margin: spacing,
        ),
      );
      if (rowContents.length == 2 * numberOfColumns + 1) {
        rows.add(Row(
          children: rowContents,
        ));
        rows.add(Container(
          margin: spacing,
        ));
        rowContents = <Widget>[];
        rowContents.add(
          Container(
            margin: spacing,
          ),
        );
      }
    }

    rows.add(Row(
      children: rowContents,
    ));

    return Column(
      children: rows,
    );
  }
}
