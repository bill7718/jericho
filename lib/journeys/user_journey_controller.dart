

import 'package:flutter/material.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/register/register_journey_controller.dart';
import 'package:jericho/services/user/user_services.dart';

import 'event_handler.dart';

abstract class UserJourneyController implements EventHandler {

  static const registerUserJourney = 'registerUser';
  static const captureOrganisationJourney = 'captureOrganisation';


  static const String initialEvent = 'initial';
  static const String startEvent = 'start';
  static const String nextEvent = 'next';
  static const String backEvent = 'back';

  static const StepOutput emptyOutput = EmptyStepOutput();


  String get currentRoute;

}

class UserJourneyNavigator {

  void goTo(BuildContext context, String route, EventHandler handler, StepInput input) {

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return getPage(route, handler, input);
    }));
  }

  void goDownTo(BuildContext context, String route, EventHandler handler, StepInput input) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return getPage(route, handler, input);
    }));
  }

  void goUp(BuildContext context) {
    Navigator.pop(context);
  }

  void gotoNextJourney(BuildContext context, String journeyRoute) {
    var journey = getJourney(journeyRoute);
    journey.handleEvent(context, event: UserJourneyController.startEvent);
  }

  void gotDownToNextJourney(BuildContext context, String journeyRoute) {
    var journey = getJourney(journeyRoute);
    journey.handleEvent(context, event: UserJourneyController.initialEvent);
  }

  Widget getPage(String route, EventHandler handler, StepInput input) {
    switch (route) {
      case RegisterJourneyController.personalDetailsRoute:
        return PersonalDetailsPage(inputState: input, eventHandler: handler,);

      default:
        throw Exception ('bad route');
    }
  }

  UserJourneyController getJourney(String route) {
    switch (route) {
      case UserJourneyController.registerUserJourney:
        return RegisterJourneyController(this, UserServices());
      default:
        throw Exception ('bad route');
    }

  }

}


class UserJourneyException implements Exception {
  final String _message;

  UserJourneyException(this._message);

  @override
  String toString() => _message;
}





