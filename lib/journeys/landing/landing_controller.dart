import 'dart:async';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/landing/landing_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';


///
/// Controls the flow of control from within the landing page
///
///
///
///
class LandingController extends UserJourneyController {
  static const String landingPageRoute = '/landing';



  String _currentRoute = '';

  final Map<String, String> eventJourney = <String, String> {
    LandingPage.inviteToOrganisationEvent: UserJourneyController.inviteToOrganisationJourney,
    LandingPage.createLiturgyEvent: UserJourneyController.createLiturgyJourney,
  };

  final UserJourneyNavigator _navigator;
  final SessionState _session;

  LandingController(this._navigator, this._session);

  @override
  Future<void> handleEvent(dynamic context,
      {String event = UserJourneyController.startEvent,
      StepOutput output = UserJourneyController.emptyOutput}) async {
    var c = Completer<void>();
    try {
      switch (_currentRoute) {
        case '':
          switch (event) {
            case UserJourneyController.startEvent:

              _currentRoute = landingPageRoute;
              _navigator.goTo(context, _currentRoute, this, LandingPageStateInput());

              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for Landing $event');
          }
          break;


        case landingPageRoute:
          _navigator.gotDownToNextJourney(context, eventJourney[event] ?? '', _session);
          break;

        default:
          throw UserJourneyException('Invalid current route for Landing Journey $_currentRoute');
      }
    } catch (ex) {
      if (ex is UserJourneyException) {
        c.completeError(ex);
      } else {
        c.completeError(UserJourneyException(ex.toString()));
      }
    }
    return c.future;
  }

  @override
  String get currentRoute => _currentRoute;
}


