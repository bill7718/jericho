import 'dart:async';

import 'package:jericho/journeys/login/login_page.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/organisation_services.dart';
import 'package:jericho/services/user_services.dart';

///
/// Controls the flow of control when a user invites another user to use the service
///
class LoginController extends MappedJourneyController {

  /// The route for the [LoginPage]
  static const String loginRoute = '/login';

  /// The error reference used if the user fails to login successfully
  /// see also [ConfigurationGetter]
  static const String loginFailure = 'loginFailure';

  /// {@macro journeyState}
  final LoginState _state = LoginState();

  /// Server communication for user data
  final UserServices _services;

  /// Server communication for organisation data
  final OrganisationServices _orgServices;

  /// {@macro sessionState}
  final SessionState _session;

  @override
  String currentRoute = '';

  LoginController(UserJourneyNavigator navigator, this._services, this._orgServices, this._session) : super(navigator);

  @override
  Map<String, Map<String, dynamic>> get functionMap => {
        MappedJourneyController.initialRoute: {
          UserJourneyController.initialEvent: MappedJourneyController.goDown + loginRoute
        },
        loginRoute: {
          UserJourneyController.backEvent: MappedJourneyController.goUp,
          UserJourneyController.nextEvent: handleNextOnLogin,
        }
      };

  @override
  StepInput get state => _state;

  ///
  /// Handles the Next Event on the login page
  ///
  /// Logs the customers in, creates the user record , retrieves details of their organisation and
  /// puts all this data into the [SessionState].
  ///
  ///
  /// Finally, it goes to the LandingPage
  ///
  /// If there is an error logging in then the system redisplays the login page with an error.
  ///
  Future<void> handleNextOnLogin(context, StepOutput output) async {
    var c = Completer<void>();

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
      navigator.gotoNextJourney(context, UserJourneyController.landingPageJourney, _session);
    } else {
      _state.messageReference = loginFailure;
      navigator.goTo(context, currentRoute, this, _state);
    }

    c.complete();
    return c.future;
  }
}

///
/// Holds the internal state of the Login journey
///
class LoginState implements StepInput, LoginRequest, GetOrganisationRequest, LoginStateInput {
  @override
  String userId = '';
  @override
  String email = '';
  @override
  String password = '';

  @override
  String messageReference = '';
}
