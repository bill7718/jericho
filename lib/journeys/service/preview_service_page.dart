import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/configuration/configuration_getter.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/service/service_item.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/notus_document_helper.dart';
import 'package:jericho/widgets/preview_content.dart';
import 'package:jericho/widgets/rich_text_preview.dart';
import 'package:jericho/widgets/text_splitter.dart';
import 'package:provider/provider.dart';
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

  int itemIndex = 0;
  List<ServiceItem> contents = <ServiceItem>[];

  List<Widget> widgets = <Widget>[];

  @override
  initState() {
    super.initState();
    var i = widget.inputState as PreviewServiceStateInput;
    contents.addAll(i.fullServiceContent);
    itemIndex = 0;
    widgets.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (itemIndex < contents.length) {
      switch (contents[itemIndex].type) {
        case liturgy:
          var spans = buildTextSpans(buildDocument(contents[itemIndex].data['text']));
          widgets.add(TextSplitter(
              spans: spans,
              callback: (List<SpanRange> splits) {
                setState(() {
                  contents[itemIndex].ranges.add(splits);
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
          widgets.add(YouTubeThumbnail(videoId: contents[itemIndex].videoId));
          setState(() {
            itemIndex++;
          });
          break;

        case presentation:
          widgets.add(Text('Talk: ${contents[itemIndex].name}'));
          setState(() {
            itemIndex++;
          });
          break;

        default:
          widget.eventHandler
              .handleException(context, Exception('invalid service item type $contents'), StackTrace.empty);
      }
    }


    final getter = Provider.of<ConfigurationGetter>(context);
    GlobalKey key = GlobalKey();
    final error = FormError();

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(PreviewServicePage.titleRef)),
        body: WaterlooFormContainer(
          formKey: key,
          children: <Widget>[
            WaterlooFormMessage(
              error: error,
            ),
        Expanded(child: GridView.count(crossAxisCount: 3, children: widgets)),
            WaterlooButtonRow(children: <Widget>[
              WaterlooTextButton(
                text: getter.getButtonText(previousButton),
                exceptionHandler: widget.eventHandler.handleException,
                onPressed: () =>  widget.eventHandler.handleEvent(context, event: UserJourneyController.backEvent),
              ),
              WaterlooTextButton(
                  text: getter.getButtonText(nextButton),
                  exceptionHandler:  widget.eventHandler.handleException,
                  onPressed: () {
                    var formState = key.currentState as FormState;
                    if (formState.validate()) {
                      scheduleMicrotask( () {
                        widget.eventHandler.handleEvent(context, event: UserJourneyController.nextEvent, output: PreviewServiceStateOutput(contents));
                      });
                    }
                  })
            ])
          ],
        ));

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
