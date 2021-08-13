

import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:jericho/journeys/liturgy/add_liturgy_controller.dart';
import 'package:jericho/journeys/liturgy/preivew_liturgy_page.dart';
import 'package:jericho/journeys/liturgy/record_liturgy_content_page.dart';
import 'package:jericho/journeys/liturgy/record_liturgy_name_page.dart';
import 'package:jericho/journeys/organisation/capture_organisation_controller.dart';
import 'package:jericho/journeys/organisation/invite_to_organisation_controller.dart';
import 'package:jericho/journeys/organisation/invite_to_organisation_page.dart';
import 'package:jericho/journeys/organisation/new_organisation_page.dart';
import 'package:jericho/journeys/exception_page.dart';
import 'package:jericho/journeys/landing/landing_controller.dart';
import 'package:jericho/journeys/landing/landing_page.dart';
import 'package:jericho/journeys/presentation/add_presentation_controller.dart';
import 'package:jericho/journeys/presentation/record_presentation_page.dart';
import 'package:jericho/journeys/register/capture_password_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/register/register_journey_controller.dart';
import 'package:jericho/journeys/service/add_service_controller.dart';
import 'package:jericho/journeys/service/record_service_page.dart';
import 'package:jericho/journeys/you_tube/add_you_tube_controller.dart';
import 'package:jericho/journeys/you_tube/record_you_tube_page.dart';
import 'package:jericho/services/organisation_services.dart';
import 'package:jericho/services/user_services.dart';

import 'organisation/confirm_organisation_page.dart';
import 'event_handler.dart';

abstract class UserJourneyController implements EventHandler {

  static const registerUserJourney = 'registerUser';
  static const captureOrganisationJourney = 'captureOrganisation';
  static const landingPageJourney = 'landingPage';
  static const inviteToOrganisationJourney = 'invite';
  static const createLiturgyJourney = 'createLiturgy';


  static const welcomePageRoute = 'welcomePage';


  static const String initialEvent = 'initial';
  static const String startEvent = 'start';
  static const String nextEvent = 'next';
  static const String backEvent = 'back';
  static const String cancelEvent = 'cancel';
  static const String confirmEvent = 'confirm';

  static const StepOutput emptyOutput = EmptyStepOutput();


  String get currentRoute;


  void handleException(dynamic context, Exception ex, StackTrace? st ) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ExceptionPage(ex, st: st);
    }));
  }

}

abstract class MappedJourneyController extends UserJourneyController {

  static const String goUp = 'GoUp';
  static const String goDown = 'down:';

  static const String initialRoute = '';

  Map<String, Map<String, dynamic>> get functionMap;
  final UserJourneyNavigator _navigator;

  MappedJourneyController(this._navigator);

  UserJourneyNavigator get navigator =>_navigator;

  StepInput get state;

  set currentRoute (String s);

  @override
  Future<void> handleEvent(context, {String event = '', StepOutput output = UserJourneyController.emptyOutput}) async {

    var m = functionMap[currentRoute];

    if ( m == null ) {
      throw UserJourneyException('Invalid current route for current Journey $currentRoute : ${functionMap}');
    } else {
      var action = m[event];
      if (action == null) {
        throw UserJourneyException('Invalid event $event for current Journey : route $currentRoute : ${functionMap}');
      } else {
        if (action is Function) {
          return action(context, output);
        }
        if (action is String) {
          if (action == goUp) {
            _navigator.goUp(context);
          } else {
            if (action.startsWith(goDown)) {
              currentRoute = action.substring(goDown.length);
              _navigator.goDownTo(context, action, this, state);
            } else {
              currentRoute = action;
              _navigator.goTo(context, action, this, state);
            }

          }
        }
      }

    }
  }
}




class UserJourneyNavigator {

  void goTo(dynamic context, String route, EventHandler handler, StepInput input) {

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return _getPage(route, handler, input);
    }));
  }

  void leaveJourney(dynamic context, String route) {

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return getPageWithoutJourney(route);
    }));
  }

  void goDownTo(dynamic context, String route, EventHandler handler, StepInput input) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(route, handler, input);
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

  Widget _getPage(String route, EventHandler handler, StepInput input) {
    switch (route) {
      case RegisterJourneyController.personalDetailsRoute:
        return PersonalDetailsPage(inputState: input, eventHandler: handler,);

      case RegisterJourneyController.capturePasswordRoute:
        return CapturePasswordPage(inputState: input, eventHandler: handler,);

      case CaptureOrganisationController.newOrganisationRoute:
        return NewOrganisationPage(inputState: input, eventHandler: handler,);

      case CaptureOrganisationController.confirmOrganisationRoute:
        return ConfirmOrganisationPage(inputState: input, eventHandler: handler,);

      case LandingController.landingPageRoute:
        return LandingPage(inputState: input, eventHandler: handler,);

      case InviteToOrganisationController.inviteToOrganisationRoute:
        return InviteToOrganisationPage(inputState: input, eventHandler: handler,);

      case AddLiturgyController.recordLiturgyNameRoute:
        return RecordLiturgyNamePage(inputState: input, eventHandler: handler,);

      case AddLiturgyController.recordLiturgyContentRoute:
        return RecordLiturgyContentPage(inputState: input, eventHandler: handler,);

      case AddLiturgyController.previewLiturgyRoute:
        return PreviewLiturgyPage(inputState: input, eventHandler: handler,);

      case AddPresentationController.recordPresentationRoute:
        return RecordPresentationNamePage(inputState: input, eventHandler: handler,);

      case AddYouTubeController.recordYouTubeRoute:
        return RecordYouTubePage(inputState: input, eventHandler: handler,);

      case AddServiceController.recordServiceRoute:
        return RecordServicePage(inputState: input, eventHandler: handler,);

      default:
        throw Exception ('Bad route in get page - $route');
    }
  }

  Widget getPageWithoutJourney(String route) {
    switch (route) {
      default:
        throw Exception ('bad route');
    }
  }

  UserJourneyController getJourney(String route, SessionState session) {
    switch (route) {
      case UserJourneyController.registerUserJourney:
        return RegisterJourneyController(this, Injector.appInstance.get<UserServices>() , session);

      case UserJourneyController.captureOrganisationJourney:
        return CaptureOrganisationController(this, Injector.appInstance.get<OrganisationServices>() , session);

      case UserJourneyController.landingPageJourney:
        return LandingController(this, session);

      case UserJourneyController.createLiturgyJourney:
        //return LandingController(this, session);


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
  String _email = '';
  String name = '';

  String organisationId = '';
  String organisationName = '';

  String get userId=>_userId;
  String get email=>_email;

  set userId(String s) {
    if (_userId.isEmpty || s == _userId) {
      _userId = s;
    } else {
      throw SessionStateException('Cannot amend userId $_userId : $s');
    }

  }

  set email(String e) {
    if (_email.isEmpty || e == _email) {
      _email = e;
    } else {
      throw SessionStateException('Cannot amend email $_email : $e');
    }

  }

}



class SessionStateException implements Exception {
  final String _message;

  SessionStateException(this._message);

  @override
  String toString() => _message;
}
