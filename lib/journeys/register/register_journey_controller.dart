import 'package:flutter/material.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/register/capture_password_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/user/user_services.dart';

class RegisterJourneyController extends UserJourneyController {
  static const String personalDetailsRoute = '/personalDetails';
  static const String capturePasswordRoute = '/capturePassword';

  String _currentRoute = '';
  final RegisterUserState _state = RegisterUserState();
  final UserJourneyNavigator _navigator;
  final UserServices _services;

  RegisterJourneyController(this._navigator, this._services);

  @override
  void handleEvent( BuildContext context,
      {String event = UserJourneyController.initialEvent, StepOutput output = UserJourneyController.emptyOutput}) {
    try {
      switch (_currentRoute) {
        case '':
          switch (event) {

            case UserJourneyController.initialEvent:
              _currentRoute = personalDetailsRoute;
              _navigator.goDownTo(context, _currentRoute, this, _state);
              break;

            case UserJourneyController.startEvent:
              _currentRoute = personalDetailsRoute;
              _navigator.goTo(context, _currentRoute, this, _state);
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
              });
              break;

            case UserJourneyController.backEvent:
              _navigator.goUp(context);
              break;

            default:
              throw UserJourneyException('Invalid Event for Register Journey $event');

          }


          break;

        case capturePasswordRoute:
          switch (event)  {

            case UserJourneyController.nextEvent:


              var o = output as CapturePasswordStateOutput;
              _state.password = o.password;
              _state.message = '';
              _state.messageReference = '';

              var fr = _services.createUser(_state);
              fr.then ((response) {
                if (response.valid) {
                  _navigator.gotoNextJourney(context, UserJourneyController.captureOrganisationJourney);
                } else {
                  _state.message = response.message;
                  _state.messageReference = response.reference;
                  _navigator.goTo(context, _currentRoute, this, _state);
                }
              });
              break;

            case UserJourneyController.backEvent:
              _currentRoute = personalDetailsRoute;
              _navigator.goTo(context, _currentRoute, this, _state);
              break;

            default:
              throw UserJourneyException('Invalid Event for Register Journey $event');

          }


          break;

        default:
          throw UserJourneyException('Invalid current route for Register Journey $_currentRoute');
      }



    } catch (ex) {
      if (ex is UserJourneyException) {
        rethrow;
      } else {
        throw UserJourneyException(ex.toString());
      }

    }
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
