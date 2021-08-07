import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:zefyrka/zefyrka.dart';

///
/// Show a page that captures the content for the liturgy to be used by this user. This is then passed into the [EventHandler] for processing.
///
class RecordLiturgyContentPage extends StatelessWidget {
  static const String titleRef = 'recordLiturgyContentPage';

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
    GlobalKey key = GlobalKey();
    final error = FormError();

    ZefyrController controller = ZefyrController();
    if (i.content.isNotEmpty) {
      var list = JsonDecoder().convert(i.content);
      var list2 = [];
      for (var item in list) {
        var newItem = item;
        newItem['insert'] = item['insert'] + '\n';
        list2.add(newItem);
    }
      controller = ZefyrController(NotusDocument.fromJson(list2));
    }
    controller.addListener(() {
      var json = controller.document.toJson();
      state.content = JsonEncoder().convert(json).replaceAll('\n', '');
    });

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
        body: WaterlooLongFormContainer(formKey: key, children: <Widget>[
          WaterlooFormMessage(
            text: getter.getScreenText(initialMessage),
            error: error,
          ),
          ZefyrToolbar.basic(
            controller: controller,
            hideHeadingStyle: true,
            hideStrikeThrough: true,
            hideCodeBlock: true,
            hideHorizontalRule: true,
          ),
          Card(
              child: ZefyrEditor(
            minHeight: 400,
            controller: controller,
          )),
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
                  var formState = key.currentState as FormState;
                  if (formState.validate()) {
                    scheduleMicrotask(() {
                      eventHandler.handleEvent(context, event: UserJourneyController.nextEvent, output: state);
                    });
                  }
                })
          ])
        ]));
  }
}

abstract class RecordLiturgyContentStateInput implements StepInput {
  String get name;
  String get messageReference;
  String get content;
}

class RecordLiturgyContentDynamicState implements RecordLiturgyContentStateOutput {
  String content;

  RecordLiturgyContentDynamicState({this.content = ''});

  String toString()=>content;
}

abstract class RecordLiturgyContentStateOutput implements StepOutput {
  String get content;
}
