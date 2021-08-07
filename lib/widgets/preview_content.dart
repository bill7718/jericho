import 'dart:async';

import 'package:flutter/material.dart';

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
            var i = 0;
            while (i < splits.split.length) {
              var currentSpans = <TextSpan>[];
              if (i > 0) {
                currentSpans.addAll(spans.getRange(splits.split[i - 1], splits.split[i]));
              } else {
                currentSpans.addAll(spans.getRange(0, splits.split[i]));
              }
              widgets.add(Container(
                  width: 200,
                  height: 150,
                  color: Colors.black,
                  child: RichText(
                    text: TextSpan(children: currentSpans),
                    textScaleFactor: 0.25,
                  )));
              //child: ScalableRichText(scale: 0.1, spans: currentSpans)));
              i++;
            }
            return SimpleGridView(
              children: widgets,
              numberOfColumns: 2,
              spacing: EdgeInsets.all(5),
            );
          }
        }));
  }
}

class SpanSplit extends ChangeNotifier {
  List<int> _split = <int>[];

  setSplits(List<int> s) {
    _split.clear();
    _split.addAll(s);
    notifyListeners();
  }

  List<int> get split => _split;
}

///
/// Adds an [Offstage] widget to the tree.
///
/// This widget measures the height of the RichText widget that incorporates the list of [TextSpan]s and
/// reports in a callback.
///
class HeightMeasurer extends StatelessWidget {
  static const delay = Duration(milliseconds: 50);

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
  static const double defaultWidth = 800.0;
  static const double defaultHeight = 600.0;

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

  List<int> separators = <int>[];
  int rangeStart = 0;
  int rangeEnd = 0;

  int attemptCount = 0;

  @override
  void initState() {
    super.initState();
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
      separators.add(rangeEnd);
      rangeStart = rangeEnd;
      rangeEnd = widget.spans.length;
      if (rangeStart == rangeEnd || attemptCount > maxAttemptCount) {
        widget.callback(
          separators,
        );
      } else {
        setState(() {});
      }
    }
  }
}

class SimpleGridView extends StatelessWidget {
  final List<Widget> children;
  final int numberOfColumns;
  final EdgeInsets spacing;

  SimpleGridView({required this.children, this.numberOfColumns = 1, this.spacing = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    // build the rows
    var i = 0;
    var rows = <Widget>[];
    while (i < children.length) {
      if (i <= children.length - 3) {
        var row = Row(
          children: [
            Container(
              margin: spacing,
            ),
            children[i],
            Container(
              margin: spacing,
            ),
            children[i + 1],
            Container(
              margin: spacing,
            ),
            children[i + 2],
          ],
        );
        rows.add(row);
      } else {
        if (i <= children.length - 2) {
          var row = Row(children: [
            Container(
              margin: spacing,
            ),
            children[i],
            Container(
              margin: spacing,
            ),
            children[i + 1],
          ]);
          rows.add(row);
        } else {
          if (i <= children.length - 1) {
            var row = Row(children: [
              Container(
                margin: spacing,
              ),
              children[i],
            ]);
            rows.add(row);
          }
        }
      }
      rows.add(Container(
        margin: spacing,
      ));
      i = i + 3;
    }
    return Column(
      children: rows,
    );
  }
}
