import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration_getter.dart';
import 'package:jericho/general/constants.dart';
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

  /// Reference for the title in the [AppBar]
  static const String titleRef = 'previewLiturgyPage';

  final dynamic inputState;

  final EventHandler eventHandler;

  const PreviewLiturgyPage({Key? key, required this.inputState, required this.eventHandler})
      : super(
          key: key,
        );

  ///
  /// This build method converts the content in the form of a [NotusDocument] to a
  /// set of [TextSpan]s. These are passed into a [PreviewContent] widget that displays the content
  ///
  @override
  Widget build(BuildContext context) {
    final i = inputState as PreviewLiturgyStateInput;

    var list = const JsonDecoder().convert(i.content);
    var list2 = [];
    for (var item in list) {
      var newItem = item;
      newItem['insert'] = item['insert'] + '\n';
      list2.add(newItem);
    }

    NotusDocument doc = NotusDocument.fromJson(list2);
    final spans = buildTextSpans(doc);
    final getter = Provider.of<ConfigurationGetter>(context);
    final error = FormError();

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
        body: Column(children: <Widget>[
          WaterlooFormMessage(
            error: error,
          ),
          PreviewContent(
            spans: spans,
          ),
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

///
/// Defines the required input fields for this page
///
abstract class PreviewLiturgyStateInput implements StepInput {
  String get name;
  String get messageReference;
  String get content;
}
