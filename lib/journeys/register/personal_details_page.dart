import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/journeys/validators.dart';
import 'package:provider/provider.dart';
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
    final getter = Provider.of<ConfigurationGetter>(context);
    GlobalKey key = GlobalKey();

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
        body: WaterlooFormContainer(
          formKey: key,
          exceptionHandler: exceptionHandler,
          children: <Widget>[
            const WaterlooFormMessage(),
            WaterlooTextField(
                value: i.name,
                put: state.setName,
                label: getter.getLabel(name),
                validator: validateName,
                ),
            WaterlooTextField(
                value: i.email,
                put: state.setEmail,
                label: getter.getLabel(email),
                validator: validateEmail,
                ),
            WaterlooButtonRow(children: <Widget>[
              WaterlooTextButton(
                text: getter.getButtonText(previous),
                exceptionHandler: exceptionHandler,
                onPressed: () => eventHandler.handleEvent(context, event: UserJourneyController.backEvent),
              ),
              WaterlooTextButton(
                  text: getter.getButtonText(next),
                  exceptionHandler: exceptionHandler,
                  onPressed: () {
                    var formState = key.currentState as FormState;
                    if (formState.validate()) {
                      eventHandler.handleEvent(context, event: UserJourneyController.nextEvent, output: state);
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

  setName(String n) => name = n;
  setEmail(String e) => email = e;

  PersonalDetailsDynamicState(this.name, this.email);
}
