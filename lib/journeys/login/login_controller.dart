import 'dart:async';

import 'package:jericho/journeys/organisation/confirm_organisation_page.dart';
import 'package:jericho/journeys/organisation/invite_to_organisation_page.dart';
import 'package:jericho/journeys/organisation/new_organisation_page.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/organisation_services.dart';
import 'package:jericho/services/user_services.dart';

///
/// Controls the flow of control when a user invites another user to use the service
///
///
class LoginController extends UserJourneyController {
  static const String loginRoute = '/login';

  String _currentRoute = '';
  final LoginState _state = LoginState();
  final UserJourneyNavigator _navigator;
  final UserServices _services;
  final SessionState _session;

  LoginController(this._navigator, this._services, this._session);

  @override
  Future<void> handleEvent(dynamic context,
      {String event = UserJourneyController.initialEvent,
      StepOutput output = UserJourneyController.emptyOutput}) async {
    var c = Completer<void>();
    try {
      switch (_currentRoute) {
        case '':
          switch (event) {
            case UserJourneyController.initialEvent:

              _currentRoute = loginRoute;
              _navigator.goDownTo(context, _currentRoute, this, _state);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for LoginController $event');
          }
          break;



        case loginRoute:
          switch (event) {
            case UserJourneyController.nextEvent:
              var r = output as InviteToOrganisationOutputState;
              _state.email = r.email;
              var response = await _services.login(_state);
              _session.userId = response.userId;
              _session.email = _state.email;


              _navigator.goUp(context);
              c.complete();
              break;

            case UserJourneyController.backEvent:
              _navigator.goUp(context);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for Login $event - ${_currentRoute}');
          }

          break;

        default:
          throw UserJourneyException('Invalid current route for Login $_currentRoute');
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

///
/// Holds the internal state of the capture organisation journey
///
class LoginState implements StepInput, LoginRequest {

  String email = '';
  String password = '';
}
