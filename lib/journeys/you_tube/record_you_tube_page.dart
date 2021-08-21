import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration_getter.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/you_tube_services.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:waterloo/waterloo_text_field.dart';
import 'package:waterloo/you_tube.dart';

///
/// Show a page that captures the name for the you tube to be used by this user. This is then passed into the [EventHandler] for processing.
///
class RecordYouTubePage extends StatelessWidget {
  static const String titleRef = 'recordYoutubePage';

  static const String videoNameLabel = 'videoName';
  static const String videoIdLabel = 'videoId';

  final dynamic inputState;
  final EventHandler eventHandler;

  const RecordYouTubePage({Key? key, required this.inputState, required this.eventHandler})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final i = inputState as RecordYouTubeStateInput;
    final state = RecordYouTubeDynamicState(i.name, i.videoId);
    final getter = Provider.of<ConfigurationGetter>(context);
    final validator = Provider.of<YouTubeValidator>(context);
    GlobalKey key = GlobalKey();
    final error = FormError();

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
        body: WaterlooFormContainer(
          formKey: key,
          children: <Widget>[
            WaterlooFormMessage(
              error: error,
            ),
            WaterlooTextField(
              initialValue: state.name,
              valueBinder: (v) { state.name = v; },
              label: getter.getLabel(videoNameLabel),
              validator: validator.validateName,
            ),
            WaterlooTextField(
              initialValue: state.videoId,
              valueBinder: (v) { state.videoId = v; },
              label: getter.getLabel(videoIdLabel),
              validator: validator.validateVideoIdentifier,
            ),
            NotifiableYouTubeThumbnail(videoId: state.videoIdentifier),
            WaterlooButtonRow(children: <Widget>[
              WaterlooTextButton(
                text: getter.getButtonText(previousButton),
                exceptionHandler: eventHandler.handleException,
                onPressed: () => eventHandler.handleEvent(context, event: UserJourneyController.backEvent),
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
          ],
        ));
  }
}

abstract class RecordYouTubeStateInput implements StepInput {
  String get name;
  String get messageReference;
  String get videoId;
}

class RecordYouTubeDynamicState
    implements RecordYouTubeStateOutput, StepOutput {

  RecordYouTubeDynamicState(this.name, String? videoId) {
    this.videoId = videoId ?? '';
  }

  @override
  String name = '';

  ValueNotifier<String> videoIdentifier = ValueNotifier<String>('');

  @override
  String get videoId =>videoIdentifier.value;

  set videoId (String v) {
    var start = v.indexOf('v=');
    if (start == -1) {
      videoIdentifier.value = v;
    } else {
      var end = v.indexOf('&', start);
      if (end == -1) {
        videoIdentifier.value = v.substring(start + 2);
      } else {
        videoIdentifier.value = v.substring(start + 2, end);
      }
    }
  }


  @override
  String toString()=>'$name - $videoId';
}

abstract class RecordYouTubeStateOutput {
  String get name;
  String get videoId;
}
