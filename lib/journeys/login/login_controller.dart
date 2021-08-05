import 'dart:async';

import 'package:jericho/journeys/login/login_page.dart';
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
  static const String loginFailure = 'loginFailure';

  String _currentRoute = '';
  final LoginState _state = LoginState();
  final UserJourneyNavigator _navigator;
  final UserServices _services;
  final OrganisationServices _orgServices;
  final SessionState _session;

  LoginController(this._navigator, this._services, this._orgServices, this._session);

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
              var r = output as LoginStateOutput;
              _state.messageReference = '';
              _state.email = r.email;
              _state.password = r.password;
              var response = await _services.login(_state);

              if (response.valid) {
                _state.userId = response.userId;
                _session.userId = response.userId;
                _session.email = _state.email;
                var orgResponse = await _orgServices.getOrganisation(_state);
                _session.organisationId = orgResponse.organisationId;
                _session.organisationName = orgResponse.organisationName;
                _navigator.goUp(context);
              } else {
                _state.messageReference = loginFailure;
                _navigator.goTo(context, _currentRoute, this, _state);
              }




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
class LoginState implements StepInput, LoginRequest, GetOrganisationRequest, LoginStateInput {

  String userId = '';
  String email = '';
  String password = '';

  @override
  String messageReference = '';
}
