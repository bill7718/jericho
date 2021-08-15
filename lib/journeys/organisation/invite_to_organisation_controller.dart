import 'dart:async';

import 'invite_to_organisation_page.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/organisation_services.dart';

///
/// Controls the flow of control when a user invites another user to use the service
///
///
class InviteToOrganisationController extends MappedJourneyController {
  static const String inviteToOrganisationRoute = '/inviteOrganisation';

  @override
  String currentRoute = '';

  /// {@macro journeyState}
  final InviteToOrganisationState _state = InviteToOrganisationState();

  /// Server communication for organisation data
  final OrganisationServices _services;

  /// {@macro sessionState}
  final SessionState _session;

  InviteToOrganisationController(UserJourneyNavigator navigator, this._services, this._session) : super(navigator);

  @override
  StepInput get state => _state;

  @override
  Map<String, Map<String, dynamic>> get functionMap => {
        MappedJourneyController.initialRoute: {
          UserJourneyController.initialEvent: MappedJourneyController.goDown + inviteToOrganisationRoute
        },
        inviteToOrganisationRoute: {
          UserJourneyController.backEvent: MappedJourneyController.goUp,
          UserJourneyController.nextEvent: handleNextOnInvite,
        },
      };

  ///
  /// Creates the invitation and returns to the calling page
  ///
  Future<void> handleNextOnInvite(context, StepOutput output) async {
    var c = Completer<void>();

    var r = output as InviteToOrganisationOutputState;
    _state.email = r.email;
    await _services.createOrganisationInvitation(
        CreateOrganisationInvitationRequest(_state.email ?? '', _session.organisationId, _session.organisationName));

    navigator.goUp(context);

    c.complete();
    return c.future;
  }
}

///
/// {@macro journeyState}
///
class InviteToOrganisationState implements StepInput {
  String? email;
}
