import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/login/login_controller.dart';
import 'package:jericho/journeys/login/login_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';

import '../../mocks/mocks.dart';
import '../../mocks/services/mock_organisation_services.dart';
import '../../mocks/services/mock_user_services.dart';

void main() {
  MockUserNavigator navigator = MockUserNavigator();
  MockOrganisationServices orgServices = MockOrganisationServices();
  MockUserServices services = MockUserServices();
  SessionState session = SessionState();

  LoginController controller = LoginController(navigator, services, orgServices, session);
  var context = '';

  setUp(() async {
    navigator = MockUserNavigator();
    services = MockUserServices();
    orgServices = MockOrganisationServices();
    session = SessionState();
    context = 'hello';
    controller = LoginController(navigator, services, orgServices, session);
  });

  group('Start of journey', () {
    testWidgets(
        'When the system initiates the journey  the system shows the Login page ',
        (WidgetTester tester) async {

      await controller.handleEvent(context, event: UserJourneyController.initialEvent);
      expect(navigator.currentRoute, LoginController.loginRoute);
      expect(navigator.level, 1);
      var i = navigator.currentInput as LoginStateInput;
      expect(i.messageReference.isEmpty, true);
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

  group('Current route is Login', () {
    setUp(() async {
      await controller.handleEvent(context, event: UserJourneyController.initialEvent);
    });

    testWidgets(
        'When the system receives a next event in Login with a valid username and password then the system calls login and goes to the landing page ',
        (WidgetTester tester) async {
      await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: LoginDynamicState(MockUserServices.existingEmail , 'hello1234'));
      expect(navigator.level, 1);

      expect(session.userId, MockUserServices.existingUserId);
      expect(session.email, MockUserServices.existingEmail);
      expect(session.organisationId, MockOrganisationServices.existingOrganisationId);
      expect(session.organisationName, MockOrganisationServices.existingOrganisationName);
      expect(navigator.currentJourney, UserJourneyController.landingPageJourney);
    });

    testWidgets(
        'When the system receives a next event in Login with an invalid username and password then the system calls login but stay where it is ',
            (WidgetTester tester) async {
          await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: LoginDynamicState('dummy@dummy.com' , 'hello1234'));
          expect(navigator.level, 1);

          expect(session.userId.isEmpty,  true);
          expect(session.email.isEmpty,  true);
          expect(session.organisationId.isEmpty, true);
          expect(session.organisationName.isEmpty,  true);
          expect(navigator.currentJourney.isEmpty,  true);
          var i = navigator.currentInput as LoginStateInput;
          expect(i.messageReference, LoginController.loginFailure);
        });

    testWidgets('When the user selects back the system goes to the welcome page', (WidgetTester tester) async {
      await controller.handleEvent(context, event: UserJourneyController.backEvent);
      expect(navigator.level, 0);
    });

    testWidgets(
        'When the system provides an invalid event at the login route the system throws an exception',
        (WidgetTester tester) async {
      try {
        await controller.handleEvent(context, event: UserJourneyController.startEvent);
        expect(true, false);
      } catch (ex) {
        expect(ex is UserJourneyException, true);
        expect(ex.toString().contains(UserJourneyController.startEvent), true);
        expect(ex.toString().contains(LoginController.loginRoute), true);
      }
    });
  });

}
