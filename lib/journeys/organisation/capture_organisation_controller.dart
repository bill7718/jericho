import 'dart:async';

import 'confirm_organisation_page.dart';
import 'new_organisation_page.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/organisation_services.dart';

///
/// Controls the flow of control when a user captures or confirms the organisation that they are registering with
///
/// a. On entry the system checks to see if the user has been invited ot join an organisation
/// b. If Yes then the system asks them to confirm that this is right organisation
/// c. If no then the system asks them to Create their own one
/// d. Then the system continues on to the Landing Page
///
/// If the user does not want to join the provided organisation or they think they should be joining one but are not invited
/// the system allows them to quit the journey without being linked ot an organisation.
///
/// In this case they are taken bakc to the welcome page with no journey in scope.
///
///
class CaptureOrganisationController extends UserJourneyController {
  static const String newOrganisationRoute = '/newOrganisation';
  static const String confirmOrganisationRoute = '/confirmOrganisation';

  String _currentRoute = '';
  final CaptureOrganisationState _state = CaptureOrganisationState();
  final UserJourneyNavigator _navigator;
  final OrganisationServices _services;
  final SessionState _session;

  CaptureOrganisationController(this._navigator, this._services, this._session);

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
              var response =
                  await _services.checkOrganisationInvitation(CheckOrganisationInvitationRequest(_session.email));

              if (response.invitationFound) {
                _state.organisationName = response.organisationName;
                _state.organisationId = response.organisationId;

                _currentRoute = confirmOrganisationRoute;
                _navigator.goTo(context, _currentRoute, this, _state);
              } else {
                _currentRoute = newOrganisationRoute;
                _navigator.goTo(context, _currentRoute, this, _state);
              }

              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for Capture Organisation $event');
          }
          break;

        case confirmOrganisationRoute:
          switch (event) {
            case UserJourneyController.nextEvent:
              await _services.acceptOrganisationInvitation(
                  AcceptOrganisationInvitationRequest(_session.userId, _session.email, _state.organisationId));

              _session.organisationId = _state.organisationId;
              _session.organisationName = _state.organisationName;

              _navigator.gotoNextJourney(context, UserJourneyController.landingPageJourney, _session);
              c.complete();
              break;

            case UserJourneyController.backEvent:
              _navigator.leaveJourney(context, UserJourneyController.welcomePageRoute);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for Capture Organisation $event - ${_currentRoute}');
          }

          break;

        case newOrganisationRoute:
          switch (event) {
            case UserJourneyController.nextEvent:
              var r = output as NewOrganisationStateOutput;
              _state.organisationName = r.organisationName;
              var response =
                  await _services.createOrganisation(CreateOrganisationRequest(r.organisationName, _session.userId));
              _state.organisationId = response.organisationId;

              _session.organisationId = response.organisationId;
              _session.organisationName = r.organisationName;
              _navigator.gotoNextJourney(context, UserJourneyController.landingPageJourney, _session);
              c.complete();
              break;

            case UserJourneyController.backEvent:
              _navigator.leaveJourney(context, UserJourneyController.welcomePageRoute);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for Capture Organisation $event - ${_currentRoute}');
          }

          break;

        default:
          throw UserJourneyException('Invalid current route for Capture Organisation Journey $_currentRoute');
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
class CaptureOrganisationState implements StepInput, ConfirmOrganisationStateInput, NewOrganisationStateInput {
  @override
  String organisationName = '';
  String organisationId = '';
}
