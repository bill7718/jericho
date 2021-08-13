import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/organisation/new_organisation_page.dart';
import 'package:jericho/general/constants.dart';

import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/organisation_services.dart';

import '../../mocks/mocks.dart';
import '../../util.dart';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();
  });

  group('Test New Organisation Page', () {
    testWidgets('When the system initiates New Organisation Page the correct widgets are shown',
        (WidgetTester tester) async {
      MockPage page = MockPage(NewOrganisationPage(
        eventHandler: handler,
        inputState: MockNewOrganisationStateInput(),
      ));
      await tester.pumpWidget(page);

      expect(findAppBarByTitle(page.getter.getPageTitle(NewOrganisationPage.titleRef)), findsOneWidget);
      checkTextInputFields([page.getter.getLabel(NewOrganisationPage.organisationNameLabel)]);
      checkButtons([page.getter.getButtonText(nextButton), page.getter.getButtonText(previousButton)]);

      // there is no error message
      checkFormError('');
    });

    testWidgets('When the system initiates New Organisation Page with data already provided then this data is shown',
        (WidgetTester tester) async {
      MockPage page = MockPage(NewOrganisationPage(
        eventHandler: handler,
        inputState: MockNewOrganisationStateInput(organisationName: 'Org1'),
      ));
      await tester.pumpWidget(page);

      expect(find.text('Org1'), findsOneWidget);
      // there is no error message
      checkFormError('');
    });

    testWidgets('When the user clicks the previous button the system invokes the previous event',
        (WidgetTester tester) async {
      MockPage page = MockPage(NewOrganisationPage(
        eventHandler: handler,
        inputState: MockNewOrganisationStateInput(),
      ));
      await tester.pumpWidget(page);
      await tap(page.getter.getButtonText(previousButton), tester);
      expect(handler.lastEvent, UserJourneyController.backEvent);
    });

    testWidgets(
        'When the user clicks the next button without any data input the system does not invoke an event and error messages are shown',
        (WidgetTester tester) async {
      MockPage page = MockPage(NewOrganisationPage(
        eventHandler: handler,
        inputState: MockNewOrganisationStateInput(),
      ));
      await tester.pumpWidget(page);
      await tap(page.getter.getButtonText(nextButton), tester);
      expect(handler.lastEvent, '');
      expect(find.text(page.getter.getErrorMessage(OrganisationValidator.nameError)), findsOneWidget);
    });

    testWidgets('When the user clicks the next button with valid input the next event is sent with the correct data',
        (WidgetTester tester) async {
          MockPage page = MockPage(NewOrganisationPage(
            eventHandler: handler,
            inputState: MockNewOrganisationStateInput(),
          ));
      await tester.pumpWidget(page);
      await enterText(tester, page.getter.getLabel(NewOrganisationPage.organisationNameLabel), 'Bill');
      await tap(page.getter.getButtonText(nextButton), tester);
      expect(handler.lastEvent, UserJourneyController.nextEvent);
      var output = handler.lastOutput as NewOrganisationStateOutput;
      expect(output.organisationName, 'Bill');
    });
  });
}

class MockNewOrganisationStateInput implements NewOrganisationStateInput {
  @override
  final String organisationName;

  MockNewOrganisationStateInput({this.organisationName = ''});
}
