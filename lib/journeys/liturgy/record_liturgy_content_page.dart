import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/liturgy_services.dart';
import 'package:jericho/services/notus_document_helper.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:zefyrka/zefyrka.dart';

///
/// Show a page that captures the content for the liturgy to be used by this user. This is then passed into the [EventHandler] for processing.
/// {@category Pages}
///
class RecordLiturgyContentPage extends StatelessWidget {

  ///
  /// {@macro titleRef}
  ///
  static const String titleRef = 'recordLiturgyContentPage';

  ///
  /// {@macro initialMessage}
  ///
  static const String initialMessage = 'liturgyContentInitialMessage';

  final dynamic inputState;
  final EventHandler eventHandler;


  const RecordLiturgyContentPage({Key? key, required this.inputState, required this.eventHandler})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final i = inputState as RecordLiturgyContentStateInput;
    final state = RecordLiturgyContentDynamicState(content: i.content);
    final getter = Provider.of<ConfigurationGetter>(context);
    final validator = Provider.of<LiturgyValidator>(context);
    GlobalKey key = GlobalKey();
    final error = FormError();



    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
        body: WaterlooFormContainer(formKey: key, children: <Widget>[
          WaterlooFormMessage(
            text: getter.getScreenText(initialMessage),
            error: error,
          ),
          ZefyrToolbar.basic(
            controller: state.controller,
            hideHeadingStyle: true,
            hideStrikeThrough: true,
            hideCodeBlock: true,
            hideHorizontalRule: true,
          ),
          Expanded(
              child: Card(
                  child: ZefyrEditor(
            controller: state.controller,
            scrollable: true,
          ))),
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
                text: getter.getButtonText(nextButton),
                exceptionHandler: eventHandler.handleException,
                onPressed: () {
                  String? errorMessage = validator.validateLiturgyContent(state.content);
                  if (errorMessage != null) {
                    error.error = errorMessage;
                  } else {
                    scheduleMicrotask(() {
                      eventHandler.handleEvent(context, event: UserJourneyController.nextEvent, output: state);
                    });
                  }
                })
          ])
        ]));
  }
}

///
/// {@macro inputState}
///
abstract class RecordLiturgyContentStateInput implements StepInput {
  String get name;
  String get messageReference;
  String get content;

}

///
/// {@macro dynamicState}
///
class RecordLiturgyContentDynamicState implements RecordLiturgyContentStateOutput {
  @override
  String content;

  RecordLiturgyContentDynamicState({this.content = ''}) {
    _controller = ZefyrController();
    if (content.isNotEmpty) {
      _controller = ZefyrController(buildDocument(content));
    }
    controller.addListener(() {
      var json = controller.document.toJson();
      content = const JsonEncoder().convert(json).replaceAll('\n', '');
      content = content.replaceAll('\\n', '');
    });
  }

  ZefyrController? _controller;

  ZefyrController get controller => _controller!;

}

///
/// {@macro outputState}
///
abstract class RecordLiturgyContentStateOutput implements StepOutput {
  String get content;
}
