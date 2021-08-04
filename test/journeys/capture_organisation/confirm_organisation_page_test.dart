import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/organisation/confirm_organisation_page.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';

import '../../mocks/mocks.dart';
import '../../util.dart';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();
  });

  group('Test Confirm Organisation Page', () {
    testWidgets('When the system initiates Confirm Organisation Page the correct widgets are shown',
        (WidgetTester tester) async {
      MockPage page = MockPage(ConfirmOrganisationPage(
        eventHandler: handler,
        inputState: MockConfirmOrganisationStateInput(organisationName: 'Org1'),
      ));
      await tester.pumpWidget(page);

      expect(findAppBarByTitle(page.getter.getPageTitle(ConfirmOrganisationPage.titleRef)), findsOneWidget);
      expect(find.text(page.getter.getScreenText(ConfirmOrganisationPage.confirmOrganisationTextRef, parameters: ['Org1'])), findsOneWidget);
      checkButtons([page.getter.getButtonText(nextButton), page.getter.getButtonText(previousButton)]);

      // there is no error message
      checkFormError('');
    });



    testWidgets('When the user clicks the previous button the system invokes the previous event',
        (WidgetTester tester) async {
      MockPage page = MockPage(ConfirmOrganisationPage(
        eventHandler: handler,
        inputState: MockConfirmOrganisationStateInput(organisationName: 'Org1'),
      ));
      await tester.pumpWidget(page);
      await tap(page.getter.getButtonText(previousButton), tester);
      expect(handler.lastEvent, UserJourneyController.backEvent);
    });

    testWidgets('When the user clicks the next button the next event is sent with the correct data',
        (WidgetTester tester) async {
          MockPage page = MockPage(ConfirmOrganisationPage(
            eventHandler: handler,
            inputState: MockConfirmOrganisationStateInput(organisationName: 'Org1'),
          ));
      await tester.pumpWidget(page);
      await tap(page.getter.getButtonText(nextButton), tester);
      expect(handler.lastEvent, UserJourneyController.nextEvent);
      expect(handler.lastOutput is EmptyStepOutput, true);
    });
  });
}

class MockConfirmOrganisationStateInput implements ConfirmOrganisationStateInput {
  @override
  final String organisationName;

  MockConfirmOrganisationStateInput({this.organisationName = ''});
}
