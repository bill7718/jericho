import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/journeys/validators.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:waterloo/waterloo_text_field.dart';

import '../exception_handler.dart';

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
    GlobalKey key = GlobalKey();

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getPageTitle(titleRef)),
        body: WaterlooFormContainer(
          formKey: key,
          exceptionHandler: exceptionHandler,
          children: <Widget>[
            const WaterlooFormMessage(),
            WaterlooTextField(
                value: i.name,
                put: state.setName,
                label: 'Name',
                validator: validateName,
                ),
            WaterlooTextField(
                value: i.email,
                put: state.setEmail,
                label: 'Email Address',
                validator: validateEmail,
                ),
            WaterlooButtonRow(children: <Widget>[
              WaterlooTextButton(
                text: 'Previous',
                exceptionHandler: exceptionHandler,
                onPressed: () => eventHandler.handleEvent(context, event: UserJourneyController.backEvent),
              ),
              WaterlooTextButton(
                  text: 'Next',
                  exceptionHandler: exceptionHandler,
                  onPressed: () {
                    var formState = key.currentState as FormState;
                    if (formState.validate()) {
                      var output = PersonalDetailsStateOutput(state.name, state.email);
                      eventHandler.handleEvent(context, event: UserJourneyController.nextEvent, output: output);
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

class PersonalDetailsStateOutput implements StepOutput {
  final String name;
  final String email;

  PersonalDetailsStateOutput(this.name, this.email);
}

class PersonalDetailsDynamicState {
  String name;
  String email;

  setName(String n) => name = n;
  setEmail(String e) => email = e;

  PersonalDetailsDynamicState(this.name, this.email);
}
