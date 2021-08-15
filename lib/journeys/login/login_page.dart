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
/// Show a page that captures email address and password.
/// This is then passed into the [EventHandler] for processing where it is used to log the user in to the system.
/// {@category Pages}
class LoginPage extends StatelessWidget {

  ///
  /// {@macro titleRef}
  ///
  static const String titleRef = 'loginPage';

  final dynamic inputState;
  final EventHandler eventHandler;

  const LoginPage({Key? key, required this.inputState, required this.eventHandler})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final i = inputState as LoginStateInput;
    final state = LoginDynamicState(i.email, i.password);
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
              initialValue: state.email,
              valueBinder: state.setEmail,
              label: getter.getLabel(emailLabel),
              validator: validator.validateEmail,
            ),
            WaterlooTextField(
              initialValue: state.password,
              valueBinder: state.setPassword,
              obscure: true,
              label: getter.getLabel(passwordLabel),
              validator: validator.validatePassword,
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
abstract class LoginStateInput implements StepInput {
  String get password;
  String get email;
  String get messageReference;
}

///
/// {@macro outputState}
///
abstract class LoginStateOutput implements StepOutput {
  String get password;
  String get email;
}

///
/// {@macro dynamicState}
///
class LoginDynamicState implements LoginStateOutput {
  @override
  String password;
  @override
  String email;

  /// {@macro setter}
  setPassword(String? p)=>password = p ?? '';

  /// {@macro setter}
  setEmail(String? e)=>email = e ?? '';

  LoginDynamicState(this.email, this.password);
}
