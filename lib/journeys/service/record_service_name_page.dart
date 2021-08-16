


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/service_services.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:waterloo/waterloo_text_field.dart';

///
/// Show a page that captures the name for the service to be used by this user. This is then passed into the [EventHandler] for processing.
/// {@category Pages}
///
class RecordServiceNamePage extends StatelessWidget {

  ///
  /// {@macro titleRef}
  ///
  static const String titleRef = 'recordServiceNamePage';

  static const String serviceNameLabel = 'serviceName';

  final dynamic inputState;
  final EventHandler eventHandler;

  const RecordServiceNamePage({Key? key, required this.inputState, required this.eventHandler})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final i = inputState as RecordServiceNameStateInput;
    final state = RecordServiceNameDynamicState(i.name);
    final getter = Provider.of<ConfigurationGetter>(context);
    final validator = Provider.of<ServiceValidator>(context);
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
              valueBinder: (v) => { state.name = v },
              label: getter.getLabel(serviceNameLabel),
              validator: validator.validateServiceName,
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


///
/// {@macro inputState}
///
abstract class RecordServiceNameStateInput implements StepInput {
  String get name;
  String get messageReference;
}

///
/// {@macro dynamicState}
///
class RecordServiceNameDynamicState implements RecordServiceNameStateOutput {
  @override
  String name = '';

  RecordServiceNameDynamicState(this.name);

}

///
/// {@macro outputState}
///
abstract class RecordServiceNameStateOutput implements StepOutput {
  String get name;
}

