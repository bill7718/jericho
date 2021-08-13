import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jericho/journeys/configuration/configuration_getter.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/journeys/validators.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:waterloo/waterloo_text_field.dart';

///
/// Show a page that captures email address and name. This is then passed into the [EventHandler] for processing.
///
class PersonalDetailsPage extends StatelessWidget {
  static const String titleRef = 'personalDetailsPage';

  final dynamic inputState;
  final EventHandler eventHandler;

  const PersonalDetailsPage({Key? key, required this.inputState, required this.eventHandler})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final i = inputState as PersonalDetailsStateInput;
    final state = PersonalDetailsDynamicState(i.name, i.email);
    final getter = Provider.of<ConfigurationGetter>(context);
    final validator = Provider.of<Validator>(context);
    GlobalKey key = GlobalKey();
    final error = FormError();
    if (i.messageReference.isNotEmpty) {
      error.error = getter.getErrorMessage(i.messageReference);
    }

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
              label: getter.getLabel(nameLabel),
              validator: validator.validateName,
            ),
            WaterlooTextField(
              initialValue: state.email,
              valueBinder: state.setEmail,
              label: getter.getLabel(emailLabel),
              validator: validator.validateEmail,
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

abstract class PersonalDetailsStateInput implements StepInput {
  String get name;
  String get email;
  String get messageReference;
}

abstract class PersonalDetailsStateOutput implements StepOutput {
  String get name;
  String get email;
}

class PersonalDetailsDynamicState implements PersonalDetailsStateOutput {
  @override
  String name;
  @override
  String email;

  setName(String? n)=>name = n ?? '';
  setEmail(String? e)=>email = e ?? '';

  PersonalDetailsDynamicState(this.name, this.email);
}
