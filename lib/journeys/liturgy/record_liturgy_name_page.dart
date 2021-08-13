
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration_getter.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/liturgy_services.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:waterloo/waterloo_text_field.dart';

///
/// Show a page that captures the name for the liturgy to be used by this user. This is then passed into the [EventHandler] for processing.
///
class RecordLiturgyNamePage extends StatelessWidget {
  static const String titleRef = 'recordLiturgyNamePage';

  static const String liturgyNameLabel = 'liturgyName';

  final dynamic inputState;
  final EventHandler eventHandler;

  const RecordLiturgyNamePage({Key? key, required this.inputState, required this.eventHandler})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final i = inputState as RecordLiturgyNameStateInput;
    final state = RecordLiturgyNameDynamicState(i.name);
    final getter = Provider.of<ConfigurationGetter>(context);
    final validator = Provider.of<LiturgyValidator>(context);
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
              valueBinder: state.setName,
              label: getter.getLabel(liturgyNameLabel),
              validator: validator.validateLiturgyName,
            ),
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



abstract class RecordLiturgyNameStateInput implements StepInput {
  String get name;
  String get messageReference;
}

class RecordLiturgyNameDynamicState implements RecordLiturgyNameStateOutput {

  String name = '';

  setName(String n)=>name=n;

  RecordLiturgyNameDynamicState(this.name);


  String toString()=>'Name $name';
}

abstract class RecordLiturgyNameStateOutput implements StepOutput {
  String get name;

}