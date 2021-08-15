import 'dart:async';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/register/capture_password_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/user_services.dart';

///
/// Controls the flow of control when a user is registered
///
/// - On entry the system shows the page that captures the email and name of the new user
/// - Then the system shows the password page.
/// - Then the system creates the user
/// - Then the system continues on to the CaptureOrganisation journey
///
class RegisterJourneyController extends MappedJourneyController {
  static const String personalDetailsRoute = '/personalDetails';
  static const String capturePasswordRoute = '/capturePassword';

  @override
  String currentRoute = '';

  /// {@macro journeyState}
  final RegisterUserState _state = RegisterUserState();

  final UserServices _services;

  /// {@macro sessionState}
  final SessionState _session;

  RegisterJourneyController(UserJourneyNavigator navigator, this._services, this._session) : super(navigator);

  @override
  StepInput get state => _state;

  @override
  Map<String, Map<String, dynamic>> get functionMap => {
    MappedJourneyController.initialRoute: {
      UserJourneyController.initialEvent: MappedJourneyController.goDown + personalDetailsRoute
    },
    personalDetailsRoute: {
      UserJourneyController.backEvent: MappedJourneyController.goUp,
      UserJourneyController.nextEvent: handleNextOnPersonalDetails,
    },
    capturePasswordRoute: {
      UserJourneyController.backEvent: personalDetailsRoute,
      UserJourneyController.nextEvent: handleNextOnCapturePassword,
    }
  };

  ///
  /// Check that the email is not already in use and then pass control to the CapturePassword  route
  ///
  Future<void> handleNextOnPersonalDetails(context, StepOutput output) async {
    var c = Completer<void>();

    var o = output as PersonalDetailsStateOutput;
    _state.email = o.email;
    _state.name = o.name;
    _state.message = '';
    _state.messageReference = '';

    var fr = _services.validateUser(_state);
    fr.then((response) {
      if (response.valid) {
        currentRoute = capturePasswordRoute;
        navigator.goTo(context, currentRoute, this, _state);
      } else {
        _state.message = response.message;
        _state.messageReference = response.reference;
        navigator.goTo(context, currentRoute, this, _state);
      }
      c.complete();
    });


    return c.future;
  }

  ///
  /// Perform a simple format check on the password and then create the user
  ///
  /// Pass control to the Capture Organisation journey
  ///
  Future<void> handleNextOnCapturePassword(context, StepOutput output) async {
    var c = Completer<void>();

    var o = output as CapturePasswordStateOutput;
    _state.password = o.password;
    _state.message = '';
    _state.messageReference = '';

    var fr = _services.createUser(_state);
    fr.then((response) {
      if (response.valid) {
        _session.userId = response.userId;
        _session.email = _state.email;
        _session.name = _state.name;
        navigator.gotoNextJourney(context, UserJourneyController.captureOrganisationJourney, _session);
      } else {
        _state.message = response.message;
        _state.messageReference = response.reference;
        navigator.goTo(context, currentRoute, this, _state);
      }
      c.complete();
    });

    return c.future;
  }
}

/// {@macro journeyState}
class RegisterUserState
    implements PersonalDetailsStateInput, CapturePasswordStateInput, StepInput, ValidateUserRequest, CreateUserRequest {
  @override
  String name = '';
  @override
  String email = '';
  @override
  String password = '';

  @override
  String messageReference = '';
  @override
  String message = '';
}
