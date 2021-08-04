import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';

///
/// Show a page that allows the user to confirm the organisation to which they have been invited. This confirmation is then passed into the [EventHandler] for processing.
///
class ConfirmOrganisationPage extends StatelessWidget {
  static const String titleRef = 'confirmOrganisationPage';

  static const String confirmOrganisationTextRef = 'confirmOrganisationFormText';

  final dynamic inputState;
  final EventHandler eventHandler;

  const ConfirmOrganisationPage({Key? key, required this.inputState, required this.eventHandler})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final i = inputState as ConfirmOrganisationStateInput;
    final getter = Provider.of<ConfigurationGetter>(context);
    GlobalKey key = GlobalKey();
    final error = FormError();

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
        body: WaterlooFormContainer(formKey: key, children: <Widget>[
          WaterlooFormMessage(
            text: getter.getScreenText(confirmOrganisationTextRef, parameters: [i.organisationName]),
            error: error,
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
                  eventHandler.handleEvent(context, event: UserJourneyController.nextEvent);
                })
          ])
        ]));
  }
}

abstract class ConfirmOrganisationStateInput implements StepInput {
  String get organisationName;
}
