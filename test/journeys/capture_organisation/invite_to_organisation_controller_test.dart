import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/organisation/capture_organisation_controller.dart';
import 'package:jericho/journeys/organisation/confirm_organisation_page.dart';
import 'package:jericho/journeys/organisation/invite_to_organisation_controller.dart';
import 'package:jericho/journeys/organisation/invite_to_organisation_page.dart';
import 'package:jericho/journeys/organisation/new_organisation_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';

import '../../mocks/mocks.dart';
import '../../mocks/services/mock_organisation_services.dart';

void main() {
  MockUserNavigator navigator = MockUserNavigator();
  MockOrganisationServices services = MockOrganisationServices();
  SessionState session = SessionState();

  InviteToOrganisationController controller = InviteToOrganisationController(navigator, services, session);
  var context = '';

  setUp(() {
    navigator = MockUserNavigator();
    services = MockOrganisationServices();
    session = SessionState();
    context = 'hello';
    controller = InviteToOrganisationController(navigator, services, session);
    session.organisationId = MockOrganisationServices.invitedOrganisationId;
    session.organisationName = MockOrganisationServices.invitedOrganisationName;
  });

  group('Start of journey', () {
    testWidgets(
        'When the system initiates the journey  the system shows the Invite User page ',
        (WidgetTester tester) async {

      await controller.handleEvent(context, event: UserJourneyController.initialEvent);
      expect(navigator.currentRoute, InviteToOrganisationController.inviteToOrganisationRoute);
      expect(navigator.level, 1);
    });



    testWidgets('When the system provides an invalid event at the start of the journey the system throws an exception',
        (WidgetTester tester) async {
      try {
        await controller.handleEvent(context, event: UserJourneyController.nextEvent);
        expect(true, false);
      } catch (ex) {
        expect(ex is UserJourneyException, true);
        expect(ex.toString().contains(UserJourneyController.nextEvent), true);
      }
    });
  });

  group('Current route is Invite User', () {
    setUp(() async {
      await controller.handleEvent(context, event: UserJourneyController.initialEvent);
    });

    testWidgets(
        'When the system receives a next event in Invite User then the system creates the user invitation and returns to the landing page ',
        (WidgetTester tester) async {
      await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: InviteToOrganisationDynamicState(email: 'hello@a.com'));
      expect(navigator.level, 0);
      expect(services.serviceCalls.last, 'createOrganisationInvitation');
      expect(services.email, 'hello@a.com');
      expect(services.organisationId, MockOrganisationServices.invitedOrganisationId);
      expect(services.organisationName, MockOrganisationServices.invitedOrganisationName);
    });

    testWidgets('When the user selects back the system goes to the welcome page', (WidgetTester tester) async {
      await controller.handleEvent(context, event: UserJourneyController.backEvent);
      expect(navigator.level, 0);
      expect(services.serviceCalls.isEmpty, true);
    });

    testWidgets(
        'When the system provides an invalid event at the confirm organisation route the system throws an exception',
        (WidgetTester tester) async {
      try {
        await controller.handleEvent(context, event: UserJourneyController.startEvent);
        expect(true, false);
      } catch (ex) {
        expect(ex is UserJourneyException, true);
        expect(ex.toString().contains(UserJourneyController.startEvent), true);
        expect(ex.toString().contains(InviteToOrganisationController.inviteToOrganisationRoute), true);
      }
    });
  });

}
