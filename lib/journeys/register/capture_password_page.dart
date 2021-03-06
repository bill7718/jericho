

import 'package:flutter/material.dart';
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
/// Show a page that captures the users password.
/// Check that the passwords are the same before passing them to the [EventHandler] for processing.
/// {@category Pages}
class CapturePasswordPage extends StatelessWidget {

  ///
  /// {@macro titleRef}
  ///
  static const String titleRef = 'capturePasswordPage';

  static const String confirmPasswordLabel = 'confirmPassword';

  /// code used for the error message displayed when the 2 passwords don't match
  static const String passwordMismatch = 'mismatchError';

  final dynamic inputState;
  final EventHandler eventHandler;

  const CapturePasswordPage({Key? key, required this.inputState, required this.eventHandler})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final i = inputState as CapturePasswordStateInput;
    final state = CapturePasswordDynamicState(i.password);
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
              initialValue: state.password,
              valueBinder: (v) => { state.password = v } ,
              label: getter.getLabel(passwordLabel),
              validator: validator.validatePassword,
              obscure: true,
            ),
            WaterlooTextField(
              initialValue: state.copyPassword,
              valueBinder: (v) => { state.copyPassword = v } ,
              label: getter.getLabel(confirmPasswordLabel),
              validator: validator.validatePassword,
              obscure: true,
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
                      if (state.password == state.copyPassword) {
                        eventHandler.handleEvent(context, event: UserJourneyController.nextEvent, output: state);
                      } else {
                        error.error = getter.getErrorMessage(passwordMismatch);
                      }

                    }
                  })
            ])
          ],
        ));
  }
}

/// {@macro inputState}
abstract class CapturePasswordStateInput implements StepInput {

  String get password;
  String get messageReference;
  String get message;


}

/// {@macro outputState}
abstract class CapturePasswordStateOutput implements StepOutput {
  String get password;
}

/// {@macro dynamicState}
class  CapturePasswordDynamicState implements CapturePasswordStateOutput {

  @override
  String password;
  String copyPassword = '';

  CapturePasswordDynamicState(this.password);

}