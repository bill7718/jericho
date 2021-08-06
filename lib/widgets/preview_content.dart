import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/event_handler.dart';
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

    return Column(
      children: [
        HeightMeasurer(width: 600.00, spans: spans, heightCallback: splits.setSplits),
        ChangeNotifierProvider<SpanSplit>.value(
            value: splits,
            child: Consumer<SpanSplit>(builder: (consumerContext, splits, _) {
              if (splits.split.isEmpty) {
                return Container();
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
                  widgets.add(RichText(text: TextSpan(children: currentSpans)));
                  i++;
                }
                return Column(
                  children: widgets,
                );
              }
            }))
      ],
    );
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

abstract class PreviewLiturgyStateInput implements StepInput {
  String get name;
  String get messageReference;
  String get content;
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
  static const double defaultWidth = 600.0;
  static const double defaultHeight = 800.0;

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
      rangeEnd = widget.spans.length - 1;
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
