
import 'package:jericho/journeys/event_handler.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jericho/journeys/configuration/configuration_getter.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/user_journey_controller.dart';

import 'package:jericho/services/organisation_services.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:waterloo/waterloo_text_field.dart';

///
/// Show a page that captures the organisation to be used by this user. This is then passed into the [EventHandler] for processing.
/// {@category Pages}
class NewOrganisationPage extends StatelessWidget {

  ///
  /// {@macro titleRef}
  ///
  static const String titleRef = 'newOrganisationPage';

  static const String organisationNameLabel = 'organisationName';

  final dynamic inputState;
  final EventHandler eventHandler;

  const NewOrganisationPage({Key? key, required this.inputState, required this.eventHandler})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final i = inputState as NewOrganisationStateInput;
    final state = NewOrganisationDynamicState(i.organisationName);
    final getter = Provider.of<ConfigurationGetter>(context);
    final validator = Provider.of<OrganisationValidator>(context);
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
              initialValue: state.organisationName,
              valueBinder: (v) => { state.organisationName = v },
              label: getter.getLabel(organisationNameLabel),
              validator: validator.validateOrganisationName,
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
abstract class NewOrganisationStateInput implements StepInput {

  String get organisationName;
}

///
/// {@macro outputState}
///
abstract class NewOrganisationStateOutput implements StepOutput {

  String get organisationName;
}

///
/// {@macro dynamicState}
///
class NewOrganisationDynamicState implements NewOrganisationStateOutput {

  @override
  String organisationName;

  NewOrganisationDynamicState(this.organisationName);
}