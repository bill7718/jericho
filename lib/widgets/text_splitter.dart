import 'package:flutter/material.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/service/service_item.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo.dart';
import 'height_measurer.dart';

class NotifiableTextSplitter extends StatelessWidget {
  final Function callback;
  final double width;
  final ChangeNotifierList<TextSpan> notifiableSpans;
  final double maxHeight;

  const NotifiableTextSplitter(
      {Key? key,
      this.width = TextSplitter.defaultWidth,
      this.maxHeight = TextSplitter.defaultHeight,
      required this.notifiableSpans,
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeNotifierList<TextSpan>>.value(
        value: notifiableSpans,
        child: Consumer<ChangeNotifierList<TextSpan>>(builder: (consumerContext, provider, _) {
          return TextSplitter(
            width: width,
            maxHeight: maxHeight,
            callback: callback,
            spans: notifiableSpans.list,
          );
        }));
  }
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
  int textScaling = 10;

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

    rangeEnd = widget.spans.length;
  }

  @override
  Widget build(BuildContext context) {
    attemptCount++;
    var spansToMeasure = <TextSpan>[];
    spansToMeasure.addAll(widget.spans.getRange(rangeStart, rangeEnd));

    return HeightMeasurer(
        width: widget.width, spans: scaleTextSpans(spansToMeasure,  textScaling), heightCallback: heightCallback);
  }

  void heightCallback(double height) {
    if (height > widget.maxHeight * textScaling) {
      setState(() {
        rangeEnd--;
      });
    } else {
      if (rangeStart < rangeEnd) {
        separators.add(SpanRange(rangeStart, rangeEnd));
        rangeStart = rangeEnd;
        rangeEnd = widget.spans.length;

        rangeStart = nextNonEmptyIndex(widget.spans, rangeStart);
      }


      if (rangeStart == rangeEnd || attemptCount > maxAttemptCount) {
        widget.callback(
          separators,
        );
      } else {
        setState(() {});
      }
    }
  }

  int nextNonEmptyIndex(List<TextSpan> spans, int startIndex) {
    var i = startIndex;
    if (i == spans.length) {
      return i;
    }
    String? s = spans[i].text;
    if (s == null) {
      i++;
      return nextNonEmptyIndex(spans, i);
    } else {
      s = s.replaceAll('\n', '');
      if (s.trim().isEmpty) {
        i++;
        return nextNonEmptyIndex(spans, i);
      } else {
        return i;
      }
    }
  }

  List<TextSpan> scaleTextSpans(List<TextSpan> spans, int scale) {
    var scaledSpans = <TextSpan>[];
    for (var span in spans) {
      scaledSpans
          .add(TextSpan(text: span.text, style: span.style?.copyWith(fontSize: (span.style?.fontSize ?? 0) / scale)));
    }
    return scaledSpans;
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
