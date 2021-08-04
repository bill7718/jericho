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
/// The main Landing Page for the application
///
class LandingPage extends StatelessWidget {
  static const String titleRef = 'landingPage';

  final dynamic inputState;
  final EventHandler eventHandler;

  const LandingPage({Key? key, required this.inputState, required this.eventHandler})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final i = inputState as LandingPageStateInput;
    final getter = Provider.of<ConfigurationGetter>(context);
    GlobalKey key = GlobalKey();
    final error = FormError();

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
        body: WaterlooFormContainer(formKey: key, children: <Widget>[
          WaterlooFormMessage(
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

class LandingPageStateInput implements StepInput {

}
