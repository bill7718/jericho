import 'package:flutter/material.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/services/notus_document_helper.dart';
import 'package:jericho/widgets/preview_content.dart';
import 'package:jericho/widgets/rich_text_preview.dart';
import 'package:waterloo/you_tube.dart';

class PreviewServicePage extends StatefulWidget {
  static const String titleRef = 'previewServicePage';

  final dynamic inputState;
  final EventHandler eventHandler;

  const PreviewServicePage({Key? key, required this.inputState, required this.eventHandler})
      : super(
          key: key,
        );
  @override
  State<StatefulWidget> createState() => PreviewServiceState();
}

class PreviewServiceState extends State<PreviewServicePage> {
  static const String liturgy = 'Liturgy';
  static const String youTube = 'YouTube';
  static const String presentation = 'Presentation';

  int itemIndex = 0;
  List<Map<String, dynamic>> contents = [];

  List<Widget> widgets = <Widget>[];

  @override
  initState() {
    super.initState();
    var i = widget.inputState as PreviewServiceNameStateInput;
    contents = i.fullServiceContent;
    itemIndex = 0;
    widgets.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (itemIndex < contents.length) {
      switch (contents[itemIndex]['type']) {
        case liturgy:
          var spans = buildTextSpans(buildDocument(contents[itemIndex]['text']));
          widgets.add(TextSplitter(
              spans: spans,
              callback: (splits) {
                setState(() {
                  widgets.removeLast();
                  for (var range in splits) {
                    var currentSpans = <TextSpan>[];
                    currentSpans.addAll(spans.getRange(range.start, range.end));
                    widgets.add(RichTextPreview(spans: currentSpans));
                  }
                  itemIndex++;
                });
              }));

          break;

        case youTube:
          widgets.add(WaterlooYouTubeThumbnail(videoIdProvider: YouTubeIdProvider(contents[itemIndex])));
          setState(() {
            itemIndex++;
          });
          break;

        case presentation:
          widgets.add(Text('Talk: ${contents[itemIndex]['name']}'));
          setState(() {
            itemIndex++;
          });
          break;

        default:
          widget.eventHandler
              .handleException(context, Exception('invalid service item type $contents'), StackTrace.empty);
      }
    }

    return GridView.count(crossAxisCount: 3, children: widgets);
  }
}

abstract class PreviewServiceNameStateInput extends StepInput {
  String get name;
  List<Map<String, dynamic>> get fullServiceContent;
}

class YouTubeIdProvider extends YouTubeVideoIdProvider {
  Map<String, dynamic> map;

  YouTubeIdProvider(this.map);

  @override
  String get videoId => map['videoId'];
}
