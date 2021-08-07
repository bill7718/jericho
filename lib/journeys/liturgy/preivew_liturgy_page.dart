import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/notus_document_helper.dart';
import 'package:jericho/widgets/preview_content.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:zefyrka/zefyrka.dart';

///
/// Show a page that previews the way in which the Liturgy will appear when it is displayed.
///
class PreviewLiturgyPage extends StatelessWidget {
  static const String titleRef = 'previewLiturgyPage';

  final dynamic inputState;
  final EventHandler eventHandler;

  const PreviewLiturgyPage({Key? key, required this.inputState, required this.eventHandler})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final i = inputState as PreviewLiturgyStateInput;

    var list = JsonDecoder().convert(i.content);
    var list2 = [];
    for (var item in list) {
      var newItem = item;
      newItem['insert'] = item['insert'] + '\n';
      list2.add(newItem);
    }

    NotusDocument doc = NotusDocument.fromJson(list2);
    final spans = buildTextSpans(doc);
    final getter = Provider.of<ConfigurationGetter>(context);
    GlobalKey key = GlobalKey();
    final error = FormError();

    return Scaffold(
      appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
      body: Column(children: <Widget>[
      WaterlooFormMessage(
      error: error,

    ),
     PreviewContent(spans: spans,),
        WaterlooButtonRow(children: <Widget>[
          WaterlooTextButton(
            text: getter.getButtonText(previousButton),
            exceptionHandler: eventHandler.handleException,
            onPressed: () => eventHandler.handleEvent(context, event: UserJourneyController.backEvent),
          ),
          WaterlooTextButton(
            text: getter.getButtonText(cancelButton),
            exceptionHandler: eventHandler.handleException,
            onPressed: () => eventHandler.handleEvent(context, event: UserJourneyController.cancelEvent),
          ),
          WaterlooTextButton(
            text: getter.getButtonText(confirmButton),
            exceptionHandler: eventHandler.handleException,
            onPressed: () => eventHandler.handleEvent(context, event: UserJourneyController.confirmEvent),
          ),

        ])
    ]));

  }
}


abstract class PreviewLiturgyStateInput implements StepInput {
  String get name;
  String get messageReference;
  String get content;
}