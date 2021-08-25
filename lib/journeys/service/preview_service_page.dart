import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/configuration/configuration_getter.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/service/service_item.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/notus_document_helper.dart';
import 'package:jericho/widgets/rich_text_preview.dart';
import 'package:jericho/widgets/text_splitter.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
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

  int currentIndex = -1;
  List<ServiceItem> contents = <ServiceItem>[];

  List<Widget> widgets = <Widget>[];

  final ChangeNotifierList<TextSpan> spans = ChangeNotifierList<TextSpan>();

  @override
  initState() {
    super.initState();
    var i = widget.inputState as PreviewServiceStateInput;
    contents.addAll(i.fullServiceContent);
    currentIndex = -1;
    widgets.clear();
  }

  @override
  Widget build(BuildContext context) {
    widgets.clear();
    var index = 0;
    while (index < contents.length) {
      switch (contents[index].type) {
        case liturgy:
          var liturgySpans = buildTextSpans(buildDocument(contents[index].data['text']));
          if (contents[index].ranges.isNotEmpty) {
            for (var range in contents[index].ranges.first) {
              var currentSpans = <TextSpan>[];
              currentSpans.addAll(liturgySpans.getRange(range.start, range.end));
              widgets.add(RichTextPreview(
                spans: currentSpans,
              ));
            }
          } else {
            if (currentIndex == -1) {
              currentIndex = index;
              spans.replaceAll(liturgySpans);
            }
          }

          break;

        case youTube:
          widgets.add(YouTubeThumbnail(videoId: contents[index].videoId));
          break;

        case presentation:
          widgets.add(Text('Talk: ${contents[index].name}'));
          break;

        default:
          widget.eventHandler
              .handleException(context, Exception('invalid service item type $contents'), StackTrace.empty);
      }
      index++;
    }

    final getter = Provider.of<ConfigurationGetter>(context);
    GlobalKey key = GlobalKey();
    final error = FormError();

    return Stack(children: [
      Card(
          child: NotifiableTextSplitter(
        notifiableSpans: spans,
        callback: (List<SpanRange> list) {
          if (currentIndex > -1) {
            switch (contents[currentIndex].type) {
              case liturgy:
                setState(() {
                  contents[currentIndex].replaceRange(list);
                  currentIndex = -1;
                  widgets.clear();
                });
                break;
              default:
                widget.eventHandler.handleException(
                    context, Exception('invalid range based service item type $contents'), StackTrace.empty);
            }
          }
        },
      )),
      Scaffold(
          appBar: WaterlooAppBar.get(title: getter.getPageTitle(PreviewServicePage.titleRef)),
          body: WaterlooFormContainer(
            formKey: key,
            children: <Widget>[
              WaterlooFormMessage(
                error: error,
              ),
              Expanded(
                  child: GridView.count(
                crossAxisCount: 4,
                children: widgets,
                crossAxisSpacing: margin,
                mainAxisSpacing: margin,
                childAspectRatio: screenWidth / screenHeight,
              )),
              WaterlooButtonRow(children: <Widget>[
                WaterlooTextButton(
                    text: getter.getButtonText(previousButton),
                    exceptionHandler: widget.eventHandler.handleException,
                    onPressed: () {
                      scheduleMicrotask(() {
                        widget.eventHandler.handleEvent(context,
                            event: UserJourneyController.backEvent, output: PreviewServiceStateOutput(contents));
                      });
                    }),
                WaterlooTextButton(
                    text: getter.getButtonText(nextButton),
                    exceptionHandler: widget.eventHandler.handleException,
                    onPressed: () {
                      scheduleMicrotask(() {
                        widget.eventHandler.handleEvent(context,
                            event: UserJourneyController.nextEvent, output: PreviewServiceStateOutput(contents));
                      });
                    })
              ])
            ],
          ))
    ]);
  }
}

abstract class PreviewServiceStateInput extends StepInput {
  String get name;
  List<ServiceItem> get fullServiceContent;
}

class PreviewServiceStateOutput extends StepOutput {
  final List<ServiceItem> fullServiceContent;

  PreviewServiceStateOutput(this.fullServiceContent);
}
