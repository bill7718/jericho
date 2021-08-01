import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/register/capture_password_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/register/register_journey_controller.dart';
import 'package:jericho/journeys/user_journey_controller.dart';

import '../../mocks/mocks.dart';
import '../../util.dart';

void main() {
  MockUserNavigator navigator = MockUserNavigator();
  MockUserServices services = MockUserServices();
  SessionState session = SessionState();

  RegisterJourneyController controller = RegisterJourneyController(navigator, services, session);
  var context = '';

  setUp(() {
    navigator = MockUserNavigator();
    services = MockUserServices();
    session = SessionState();
    context = 'hello';
    controller = RegisterJourneyController(navigator, services, session);
  });

  group('Start of journey', () {
    testWidgets(
        'When the system initiates the journey the system shows the CapturePersonalDetails page and a lower level.',
        (WidgetTester tester) async {
      await controller.handleEvent(context, event: UserJourneyController.initialEvent);
      expect(navigator.currentRoute, RegisterJourneyController.personalDetailsRoute);
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

  group('Current route is Personal Details', () {
    MockPersonalDetailsOutput output = MockPersonalDetailsOutput('Bill', 'a@b.com');
    setUp(() async {
      await controller.handleEvent(context, event: UserJourneyController.initialEvent);
      output = MockPersonalDetailsOutput('Bill', 'a@b.com');
    });

    testWidgets('When the system receives a valid name and email the case moves on to the password page',
        (WidgetTester tester) async {
      await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: output);
      expect(navigator.currentRoute, RegisterJourneyController.capturePasswordRoute);
      expect(navigator.level, 1);
    });

    testWidgets('When the system receives an invalid email then the case stays on the personal details page',
        (WidgetTester tester) async {
      output = MockPersonalDetailsOutput('Bill', 'a@bademail.com');
      await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: output);
      expect(navigator.currentRoute, RegisterJourneyController.personalDetailsRoute);
      var i = navigator.currentInput as PersonalDetailsStateInput;
      expect(i.messageReference, 'duplicateUser');
    });

    testWidgets('When the user selects back the system goes up to the previous level in the journey tree',
        (WidgetTester tester) async {
      await controller.handleEvent(context, event: UserJourneyController.backEvent);
      expect(navigator.level, 0);
    });

    testWidgets(
        'When the system provides an invalid event at the personal details route the system throws an exception',
        (WidgetTester tester) async {
      try {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
        expect(true, false);
      } catch (ex) {
        expect(ex is UserJourneyException, true);
        expect(ex.toString().contains(UserJourneyController.initialEvent), true);
        expect(ex.toString().contains(RegisterJourneyController.personalDetailsRoute), true);
      }
    });
  });

  group('Current route is Capture Password', () {
    MockPersonalDetailsOutput output = MockPersonalDetailsOutput('Bill', 'a@b.com');
    MockCapturePasswordStateOutput passwordOut = MockCapturePasswordStateOutput('hello123');

    setUp(() async {
      await controller.handleEvent(context, event: UserJourneyController.initialEvent);
      output = MockPersonalDetailsOutput('Bill', 'a@b.com');
      await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: output);
    });

    testWidgets(
        'When the system receives a valid password the system creates a user and goes to the next journey (Capture Organisation)',
        (WidgetTester tester) async {
      await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: passwordOut);
      expect(navigator.currentJourney, UserJourneyController.captureOrganisationJourney);
      expect(navigator.level, 1);
      expect(session.userId, 'uid_a@b.com');
    });

    testWidgets('When the system cannot create the user the system remain on the same page',
        (WidgetTester tester) async {
      passwordOut = MockCapturePasswordStateOutput('bad123');
      await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: passwordOut);
      expect(navigator.currentRoute, RegisterJourneyController.capturePasswordRoute);
      var i = navigator.currentInput as CapturePasswordStateInput;
      expect(i.messageReference, 'createFailed');
      expect(i.message, 'bad password');
    });

    testWidgets(
        'When the system provides an invalid event at the capture password route the system throws an exception',
            (WidgetTester tester) async {
          try {
            await controller.handleEvent(context, event: UserJourneyController.initialEvent);
            expect(true, false);
          } catch (ex) {
            expect(ex is UserJourneyException, true);
            expect(ex.toString().contains(UserJourneyController.initialEvent), true);
            expect(ex.toString().contains(RegisterJourneyController.capturePasswordRoute), true);
          }
        });
  });
}
