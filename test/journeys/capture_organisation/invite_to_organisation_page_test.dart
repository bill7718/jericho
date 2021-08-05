import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/organisation/invite_to_organisation_page.dart';
import 'package:jericho/journeys/configuration/constants.dart';

import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/journeys/validators.dart';

import '../../mocks/mocks.dart';
import '../../util.dart';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();
  });

  group('Test Invite To Organisation Page', () {
    testWidgets('When the system initiates Invite To Organisation Page the correct widgets are shown',
        (WidgetTester tester) async {
      MockPage page = MockPage(InviteToOrganisationPage(
        eventHandler: handler,
        inputState: EmptyStepInput(),
      ));
      await tester.pumpWidget(page);

      expect(findAppBarByTitle(page.getter.getPageTitle(InviteToOrganisationPage.titleRef)), findsOneWidget);
      checkTextInputFields([page.getter.getLabel(emailLabel)]);
      checkButtons([page.getter.getButtonText(nextButton), page.getter.getButtonText(previousButton)]);

      // there is no error message
      checkFormError('');
    });

    testWidgets('When the user clicks the previous button the system invokes the previous event',
        (WidgetTester tester) async {
          MockPage page = MockPage(InviteToOrganisationPage(
            eventHandler: handler,
            inputState: EmptyStepInput(),
          ));
      await tester.pumpWidget(page);
      await tap(page.getter.getButtonText(previousButton), tester);
      expect(handler.lastEvent, UserJourneyController.backEvent);
    });

    testWidgets(
        'When the user clicks the next button without any data input the system does not invoke an event and error messages are shown',
        (WidgetTester tester) async {
          MockPage page = MockPage(InviteToOrganisationPage(
            eventHandler: handler,
            inputState: EmptyStepInput(),
          ));
      await tester.pumpWidget(page);
      await tap(page.getter.getButtonText(nextButton), tester);
      expect(handler.lastEvent, '');
      expect(find.text(page.getter.getErrorMessage(Validator.emailError)), findsOneWidget);
    });

    testWidgets('When the user clicks the next button with valid input the next event is sent with the correct data',
        (WidgetTester tester) async {
          MockPage page = MockPage(InviteToOrganisationPage(
            eventHandler: handler,
            inputState: EmptyStepInput(),
          ));
      await tester.pumpWidget(page);
      await enterText(tester, page.getter.getLabel(emailLabel), 'Bill@c.com');
      await tap(page.getter.getButtonText(nextButton), tester);
      expect(handler.lastEvent, UserJourneyController.nextEvent);
      var output = handler.lastOutput as InviteToOrganisationOutputState;
      expect(output.email, 'Bill@c.com');
    });
  });
}
