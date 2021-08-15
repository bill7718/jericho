
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration_getter.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/presentation_services.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_file_uploader.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:waterloo/waterloo_text_field.dart';

///
/// Show a page that captures a presentation for this user. This is then passed into the [EventHandler] for processing.
/// {@category Pages}
class RecordPresentationNamePage extends StatelessWidget {

  ///
  /// {@macro titleRef}
  ///
  static const String titleRef = 'recordPresentationNamePage';

  static const String presentationNameLabel = 'presentationName';

  final dynamic inputState;
  final EventHandler eventHandler;

  const RecordPresentationNamePage({Key? key, required this.inputState, required this.eventHandler})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final i = inputState as RecordPresentationStateInput;
    final state = RecordPresentationDynamicState(i.name);
    final getter = Provider.of<ConfigurationGetter>(context);
    final validator = Provider.of<PresentationValidator>(context);
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
            ChangeNotifierProvider<RecordPresentationDynamicState>.value(value: state,
            child: Consumer<RecordPresentationDynamicState>(
              builder: (consumerContext, value, _ ) {
                return WaterlooTextField(
                  initialValue: state.name,
                  valueBinder: (v) => { state.name = v } ,
                  label: getter.getLabel(presentationNameLabel),
                  validator: validator.validatePresentationName,
                );
              },
            )),
            WaterlooFileUploader(exceptionHandler: eventHandler.handleException,
                callback: (name, data) {
                    state.data = data;
                    state.fileName = name;
                }),
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
                      scheduleMicrotask( () {
                        eventHandler.handleEvent(context, event: UserJourneyController.nextEvent, output: state);
                      });
                    }
                  })
            ])
          ],
        ));
  }
}


///
/// {@macro inputState}
///
abstract class RecordPresentationStateInput implements StepInput {
  String get name;
  String get messageReference;
}

///
/// {@macro dynamicState}
///
class RecordPresentationDynamicState  with ChangeNotifier implements RecordPresentationStateOutput, StepOutput {
  @override
  String name = '';
  @override
  Uint8List data = Uint8List(0);
  String _fileName = '';

  set fileName(String f) {
    _fileName = f;
    if (name.isEmpty) {
      name = f;
      notifyListeners();
    }
  }

  String get fileName=>_fileName;

  RecordPresentationDynamicState(this.name);
}

///
/// {@macro outputState}
///
abstract class RecordPresentationStateOutput {

  String get name;
  Uint8List get data;
}
