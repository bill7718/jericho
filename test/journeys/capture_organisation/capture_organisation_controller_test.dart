import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/capture_organisation/capture_organisation_controller.dart';
import 'package:jericho/journeys/capture_organisation/confirm_organisation_page.dart';
import 'package:jericho/journeys/capture_organisation/new_organisation_page.dart';
import 'package:jericho/journeys/register/capture_password_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/register/register_journey_controller.dart';
import 'package:jericho/journeys/user_journey_controller.dart';

import '../../mocks/mocks.dart';
import '../../mocks/services/mock_organisation_services.dart';

void main() {
  MockUserNavigator navigator = MockUserNavigator();
  MockOrganisationServices services = MockOrganisationServices();
  SessionState session = SessionState();

  CaptureOrganisationController controller = CaptureOrganisationController(navigator, services, session);
  var context = '';

  setUp(() {
    navigator = MockUserNavigator();
    services = MockOrganisationServices();
    session = SessionState();
    context = 'hello';
    controller = CaptureOrganisationController(navigator, services, session);
  });

  group('Start of journey', () {
    testWidgets(
        'When the system initiates the journey where there is an invitation the system shows the ConfirmOrganisation page ',
        (WidgetTester tester) async {
      session.email = MockOrganisationServices.invitedEmail;
      session.userId = MockOrganisationServices.invitedUserId;
      await controller.handleEvent(context, event: UserJourneyController.initialEvent);
      expect(navigator.currentRoute, CaptureOrganisationController.confirmOrganisationRoute);
      var i = navigator.currentInput as ConfirmOrganisationStateInput;
      expect(i.organisationName, MockOrganisationServices.invitedOrganisationIName);
    });

    testWidgets(
        'When the system initiates the journey where there is no invitation the system shows the NewOrganisation page ',
        (WidgetTester tester) async {
      session.email = 'a@b.com';
      session.userId = 'anyone';
      await controller.handleEvent(context, event: UserJourneyController.initialEvent);
      expect(navigator.currentRoute, CaptureOrganisationController.newOrganisationRoute);
      var i = navigator.currentInput as NewOrganisationStateInput;
      expect(i.organisationName, '');
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

  group('Current route is Confirm Organisation', () {
    setUp(() async {
      session.email = MockOrganisationServices.invitedEmail;
      session.userId = MockOrganisationServices.invitedUserId;
      await controller.handleEvent(context, event: UserJourneyController.initialEvent);
    });

    testWidgets(
        'When the system receives a next event in Confirm Organisation then the system links the user to the organisation and goes to the landing page  ',
        (WidgetTester tester) async {
      await controller.handleEvent(context, event: UserJourneyController.nextEvent);
      expect(navigator.currentJourney, UserJourneyController.landingPageJourney);
      expect(services.serviceCalls.last, 'acceptOrganisationInvitation');
      expect(services.organisationId, MockOrganisationServices.invitedOrganisationId);
      expect(services.userId, MockOrganisationServices.invitedUserId);
      expect(services.email, MockOrganisationServices.invitedEmail);
    });

    testWidgets('When the user selects back the system goes to the welcome page', (WidgetTester tester) async {
      await controller.handleEvent(context, event: UserJourneyController.backEvent);
      expect(navigator.currentRoute, UserJourneyController.welcomePageRoute);
      expect(navigator.currentJourney.isEmpty, true);
    });

    testWidgets(
        'When the system provides an invalid event at the confirm organisation route the system throws an exception',
        (WidgetTester tester) async {
      try {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
        expect(true, false);
      } catch (ex) {
        expect(ex is UserJourneyException, true);
        expect(ex.toString().contains(UserJourneyController.initialEvent), true);
        expect(ex.toString().contains(CaptureOrganisationController.confirmOrganisationRoute), true);
      }
    });
  });

  group('Current route is Create Organisation', () {
    setUp(() async {
      session.email = 'a@b.com';
      session.userId = 'anyone';
      await controller.handleEvent(context, event: UserJourneyController.initialEvent);
    });

    testWidgets(
        'When the system receives a next event then the system creates the organisation and goes to the landing page  ',
        (WidgetTester tester) async {
      var output = NewOrganisationDynamicState('');
      output.organisationName = 'Great new org';
      await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: output);
      expect(navigator.currentJourney, UserJourneyController.landingPageJourney);
      expect(services.serviceCalls.last, 'createOrganisation');
      expect(services.userId, session.userId);
      expect(services.organisationName, output.organisationName);
      expect(session.organisationId, output.organisationName+'id');
      expect(session.organisationName, output.organisationName);
    });

    testWidgets('When the user selects back the system goes to the welcome page', (WidgetTester tester) async {
      await controller.handleEvent(context, event: UserJourneyController.backEvent);
      expect(navigator.currentRoute, UserJourneyController.welcomePageRoute);
      expect(navigator.currentJourney.isEmpty, true);
    });

    testWidgets(
        'When the system provides an invalid event at the confirm organisation route the system throws an exception',
        (WidgetTester tester) async {
      try {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
        expect(true, false);
      } catch (ex) {
        expect(ex is UserJourneyException, true);
        expect(ex.toString().contains(UserJourneyController.initialEvent), true);
        expect(ex.toString().contains(CaptureOrganisationController.newOrganisationRoute), true);
      }
    });
  });
}
