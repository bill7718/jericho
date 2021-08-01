

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

  void goTo(dynamic context, String route, EventHandler handler, StepInput input) {

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return getPage(route, handler, input);
    }));
  }

  void goDownTo(dynamic context, String route, EventHandler handler, StepInput input) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return getPage(route, handler, input);
    }));
  }

  void goUp(dynamic context) {
    Navigator.pop(context);
  }

  void gotoNextJourney(dynamic context, String journeyRoute, SessionState session) {
    var journey = getJourney(journeyRoute, session);
    journey.handleEvent(context, event: UserJourneyController.startEvent);
  }

  void gotDownToNextJourney(dynamic context, String journeyRoute, SessionState session) {
    var journey = getJourney(journeyRoute, session);
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

  UserJourneyController getJourney(String route, SessionState session) {
    switch (route) {
      case UserJourneyController.registerUserJourney:
        return RegisterJourneyController(this, UserServices(), session);
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




class SessionState  {

  String _userId = '';

  String get userId=>_userId;

  set userId(String s) {
    if (_userId.isEmpty || s == _userId) {
      _userId = s;
    } else {
      throw SessionStateException('Cannot amend userId $_userId : $s');
    }

  }

}



class SessionStateException implements Exception {
  final String _message;

  SessionStateException(this._message);

  @override
  String toString() => _message;
}
