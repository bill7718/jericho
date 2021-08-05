import 'dart:async';

import 'package:jericho/journeys/organisation/invite_to_organisation_page.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/organisation_services.dart';

///
/// Controls the flow of control when a user invites another user to use the service
///
///
class InviteToOrganisationController extends UserJourneyController {
  static const String inviteToOrganisationRoute = '/inviteOrganisation';

  String _currentRoute = '';
  final InviteToOrganisationState _state = InviteToOrganisationState();
  final UserJourneyNavigator _navigator;
  final OrganisationServices _services;
  final SessionState _session;

  InviteToOrganisationController(this._navigator, this._services, this._session);

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

              _currentRoute = inviteToOrganisationRoute;
              _navigator.goDownTo(context, _currentRoute, this, _state);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for InviteToOrganisationController $event');
          }
          break;



        case inviteToOrganisationRoute:
          switch (event) {
            case UserJourneyController.nextEvent:
              var r = output as InviteToOrganisationOutputState;
              _state.email = r.email;
              await _services.createOrganisationInvitation(
                      CreateOrganisationInvitationRequest(_state.email ?? '', _session.organisationId, _session.organisationName));

              _navigator.goUp(context);
              c.complete();
              break;

            case UserJourneyController.backEvent:
              _navigator.goUp(context);
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
class InviteToOrganisationState implements StepInput {

  String? email;
}
