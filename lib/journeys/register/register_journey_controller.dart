import 'dart:async';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/register/capture_password_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/user/user_services.dart';

///
/// Controls the flow of control when a user is registered
///
/// a. On entry the system shows the page that captures the email and name of the new user
/// b. Then the system shows the password page.
/// c. Then the system creates the user
///
class RegisterJourneyController extends UserJourneyController {
  static const String personalDetailsRoute = '/personalDetails';
  static const String capturePasswordRoute = '/capturePassword';

  String _currentRoute = '';
  final RegisterUserState _state = RegisterUserState();
  final UserJourneyNavigator _navigator;
  final UserServices _services;
  final SessionState _session;

  RegisterJourneyController(this._navigator, this._services, this._session);

  @override
  Future<void> handleEvent( dynamic context,
      { String event = UserJourneyController.initialEvent, StepOutput output = UserJourneyController.emptyOutput }) {
    var c = Completer<void>();
    try {
      switch (_currentRoute) {
        case '':
          switch (event) {

            case UserJourneyController.initialEvent:
              _currentRoute = personalDetailsRoute;
              _navigator.goDownTo(context, _currentRoute, this, _state);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for Register Journey $event');

          }
          break;

        case personalDetailsRoute:
          switch (event)  {

            case UserJourneyController.nextEvent:

              var o = output as PersonalDetailsStateOutput;
              _state.email = o.email;
              _state.name = o.name;
              _state.message = '';
              _state.messageReference = '';

              var fr = _services.validateUser(_state);
              fr.then ((response) {
                if (response.valid) {
                  _currentRoute = capturePasswordRoute;
                  _navigator.goTo(context, _currentRoute, this, _state);
                } else {
                  _state.message = response.message;
                  _state.messageReference = response.reference;
                  _navigator.goTo(context, _currentRoute, this, _state);
                }
                c.complete();
              });
              break;

            case UserJourneyController.backEvent:
              _navigator.goUp(context);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for Register Journey $event and route $_currentRoute');

          }


          break;

        case capturePasswordRoute:
          switch (event)  {

            case UserJourneyController.nextEvent:

              if (_session.userId.isNotEmpty) {
                throw UserJourneyException('Cannot create a new user for a session with an existing user: ${_session.userId} ');
              }

              var o = output as CapturePasswordStateOutput;
              _state.password = o.password;
              _state.message = '';
              _state.messageReference = '';

              var fr = _services.createUser(_state);
              fr.then ((response) {
                if (response.valid) {
                  _session.userId = response.userId;
                  _navigator.gotoNextJourney(context, UserJourneyController.captureOrganisationJourney, _session);
                } else {
                  _state.message = response.message;
                  _state.messageReference = response.reference;
                  _navigator.goTo(context, _currentRoute, this, _state);
                }
                c.complete();
              });
              break;

            case UserJourneyController.backEvent:
              _currentRoute = personalDetailsRoute;
              _navigator.goTo(context, _currentRoute, this, _state);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for Register Journey $event and route $_currentRoute');

          }


          break;

        default:
          throw UserJourneyException('Invalid current route for Register Journey $_currentRoute');
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

class RegisterUserState  implements PersonalDetailsStateInput, CapturePasswordStateInput,  StepInput,
    ValidateUserRequest, CreateUserRequest {

  @override
  String  name = '';
  @override
  String email = '';
  @override
  String password = '';

  @override
  String messageReference = '';
  String message = '';




}
