
import 'dart:async';

import 'package:flutter/material.dart';
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

///
/// Show a page that captures the email address of the user who is to be invited
///
class InviteToOrganisationPage extends StatelessWidget {
  static const String titleRef = 'newOrganisationPage';

  static const String organisationNameLabel = 'organisationName';

  final dynamic inputState;
  final EventHandler eventHandler;

  const InviteToOrganisationPage({Key? key, required this.inputState, required this.eventHandler})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {

    final state = InviteToOrganisationDynamicState();
    final getter = Provider.of<ConfigurationGetter>(context);
    final validator = Provider.of<Validator>(context);
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


class InviteToOrganisationDynamicState implements InviteToOrganisationOutputState {

  String email;

  setEmail(String? e)=>email = e ?? '';

  InviteToOrganisationDynamicState({this.email = ''});

}


abstract class InviteToOrganisationOutputState implements StepOutput {

  String get email;
}