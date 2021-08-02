import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/journeys/validators.dart';


import '../../mocks/journeys/configuration/mock_configuration.dart';
import '../../mocks/mocks.dart';
import '../../util.dart';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();

  });

  group('Test Personal Details Page', () {
    testWidgets(
        'When the system initiates Personal Details Page the correct widgets are shown',
        (WidgetTester tester) async {
          MockPage page = MockPage( PersonalDetailsPage (eventHandler: handler, inputState: MockPersonalDetails('', ''),));
          await tester.pumpWidget(page);

          expect(findAppBarByTitle(page.getter.getPageTitle(PersonalDetailsPage.titleRef)), findsOneWidget);
          checkTextInputFields([page.getter.getLabel(emailLabel), page.getter.getLabel(nameLabel)]);
          checkButtons([page.getter.getButtonText(nextButton), page.getter.getButtonText(previousButton)]);

          // there is no error message
          checkFormError('');
    });

    testWidgets(
        'When the user clicks the previous button the system invokes the previous event' ,
            (WidgetTester tester) async {
              MockPage page = MockPage( PersonalDetailsPage (eventHandler: handler, inputState: MockPersonalDetails('', ''),));
              await tester.pumpWidget(page);
              await tap(page.getter.getButtonText(previousButton), tester);
              expect(handler.lastEvent, UserJourneyController.backEvent);

    });

    testWidgets(
        'When the user clicks the next button without any data input the system does not invoke an event and error messages are shown' ,
            (WidgetTester tester) async {
          MockPage page = MockPage( PersonalDetailsPage (eventHandler: handler, inputState: MockPersonalDetails('', ''),));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(nextButton), tester);
          expect(handler.lastEvent, '');
          expect(find.text(page.getter.getErrorMessage(Validator.emailError)), findsOneWidget);
          expect(find.text(page.getter.getErrorMessage(Validator.nameError)), findsOneWidget);
        });


  });


}
