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
/// In this case they are taken back to the welcome page with no journey in scope.
///
///
class CaptureOrganisationController extends MappedJourneyController {

  /// The route for the [NewOrganisationPage]
  static const String newOrganisationRoute = '/newOrganisation';

  /// The route for the [ConfirmOrganisationPage]
  static const String confirmOrganisationRoute = '/confirmOrganisation';

  @override
  String currentRoute = '';

  /// {@macro journeyState}
  final CaptureOrganisationState _state = CaptureOrganisationState();

  /// Server communication for organisation data
  final OrganisationServices _services;

  /// {@macro sessionState}
  final SessionState _session;

  CaptureOrganisationController(UserJourneyNavigator navigator, this._services, this._session) : super(navigator);

  @override
  Map<String, Map<String, dynamic>> get functionMap => {
    MappedJourneyController.initialRoute: {
      UserJourneyController.startEvent: handleInitial
    },
    confirmOrganisationRoute: {
      UserJourneyController.backEvent: MappedJourneyController.goUp,
      UserJourneyController.nextEvent: handleNextOnConfirmOrganisation,
    },
    newOrganisationRoute: {
      UserJourneyController.backEvent: MappedJourneyController.goUp,
      UserJourneyController.nextEvent: handleNextOnNewOrganisation,
    }
  };

  ///
  /// Check to see if the user has been invited.
  ///
  /// If the user is invited, show the page that confirms the invitation
  /// If the user is not invited, show hte page that allows them to create a new organisation
  ///
  Future<void> handleInitial(context, StepOutput output) async {
    var c = Completer<void>();

    var response =
    await _services.checkOrganisationInvitation(CheckOrganisationInvitationRequest(_session.email));

    if (response.invitationFound) {
      _state.organisationName = response.organisationName;
      _state.organisationId = response.organisationId;

      currentRoute = confirmOrganisationRoute;
      navigator.goTo(context, currentRoute, this, _state);
    } else {
      currentRoute = newOrganisationRoute;
      navigator.goTo(context, currentRoute, this, _state);
    }

    c.complete();
    return c.future;
  }

  ///
  /// Calls a service to record the acceptance of the invitation.
  /// Then populate the [SessionState] with the organisation details
  ///
  Future<void> handleNextOnConfirmOrganisation(context, StepOutput output) async {
    var c = Completer<void>();

    await _services.acceptOrganisationInvitation(
        AcceptOrganisationInvitationRequest(_session.userId, _session.email, _state.organisationId));

    _session.organisationId = _state.organisationId;
    _session.organisationName = _state.organisationName;

    navigator.gotoNextJourney(context, UserJourneyController.landingPageJourney, _session);

    c.complete();
    return c.future;
  }

  ///
  /// Calls a service to record the new organisation
  /// Then populate the [SessionState] with the organisation details
  ///
  Future<void> handleNextOnNewOrganisation(context, StepOutput output) async {
    var c = Completer<void>();

    var r = output as NewOrganisationStateOutput;
    _state.organisationName = r.organisationName;
    var response =
    await _services.createOrganisation(CreateOrganisationRequest(r.organisationName, _session.userId));
    _state.organisationId = response.organisationId;

    _session.organisationId = response.organisationId;
    _session.organisationName = r.organisationName;
    navigator.gotoNextJourney(context, UserJourneyController.landingPageJourney, _session);

    c.complete();
    return c.future;
  }

  @override
  StepInput get state => _state;

}

///
/// Holds the internal state of the capture organisation journey
///
class CaptureOrganisationState implements StepInput, ConfirmOrganisationStateInput, NewOrganisationStateInput {
  @override
  String organisationName = '';
  String organisationId = '';
}
