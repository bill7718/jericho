import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/register/capture_password_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/journeys/validators.dart';

import '../../mocks/mocks.dart';
import '../../util.dart';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();

  });

  group('Test  Capture Password Page', () {
    testWidgets(
        'When the system initiates Capture Password Page the correct widgets are shown',
        (WidgetTester tester) async {
          MockPage page = MockPage( CapturePasswordPage (eventHandler: handler, inputState: MockCapturePasswordStateInput(),));
          await tester.pumpWidget(page);

          expect(findAppBarByTitle(page.getter.getPageTitle(CapturePasswordPage.titleRef)), findsOneWidget);
          checkTextInputFields([page.getter.getLabel(passwordLabel), page.getter.getLabel(CapturePasswordPage.confirmPasswordLabel)], obscure: true);
          checkButtons([page.getter.getButtonText(nextButton), page.getter.getButtonText(previousButton)]);

          // there is no error message
          checkFormError('');
    });

    testWidgets(
        'When the system initiates Capture Password Page  with data already provided then this data is shown',
            (WidgetTester tester) async {
          MockPage page = MockPage( CapturePasswordPage (eventHandler: handler, inputState: MockCapturePasswordStateInput( password: 'hello123'),));
          await tester.pumpWidget(page);

          expect(find.text('hello123'), findsOneWidget);
          // there is no error message
          checkFormError('');
        });

    testWidgets(
        'When the system initiates Capture Password Page with an error message then this is shown',
            (WidgetTester tester) async {
          MockPage page = MockPage( CapturePasswordPage (eventHandler: handler, inputState: MockCapturePasswordStateInput(messageReference: 'error1'),));
          await tester.pumpWidget(page);
          // there is an error message
          checkFormError(page.getter.getErrorMessage('error1'));
        });


    testWidgets(
        'When the user clicks the previous button the system invokes the previous event' ,
            (WidgetTester tester) async {
              MockPage page = MockPage( CapturePasswordPage (eventHandler: handler, inputState: MockCapturePasswordStateInput(),));
              await tester.pumpWidget(page);
              await tap(page.getter.getButtonText(previousButton), tester);
              expect(handler.lastEvent, UserJourneyController.backEvent);

    });

    testWidgets(
        'When the user clicks the next button without any data input the system does not invoke an event and error messages are shown' ,
            (WidgetTester tester) async {
          MockPage page = MockPage( CapturePasswordPage (eventHandler: handler, inputState:  MockCapturePasswordStateInput(),));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(nextButton), tester);
          expect(handler.lastEvent, '');
          expect(find.text(page.getter.getErrorMessage(Validator.passwordError)), findsNWidgets(2));

        });

    testWidgets(
        'When the user clicks the next button two valid but different passwords the system shows an error' ,
            (WidgetTester tester) async {
          MockPage page = MockPage( CapturePasswordPage (eventHandler: handler, inputState:  MockCapturePasswordStateInput(),));
          await tester.pumpWidget(page);
          await enterText(tester, page.getter.getLabel(passwordLabel), 'hello123');
          await enterText(tester, page.getter.getLabel(CapturePasswordPage.confirmPasswordLabel), 'hello124');
          await tap(page.getter.getButtonText(nextButton), tester);
          expect(handler.lastEvent, '');
          checkFormError(page.getter.getErrorMessage(CapturePasswordPage.passwordMismatch));

        });

    testWidgets(
        'When the user clicks the next button with valid input the next event is sent with the correct data' ,
            (WidgetTester tester) async {
          MockPage page = MockPage( CapturePasswordPage (eventHandler: handler, inputState: MockCapturePasswordStateInput(),));
          await tester.pumpWidget(page);
          await enterText(tester, page.getter.getLabel(passwordLabel), 'hello123');
          await enterText(tester, page.getter.getLabel(CapturePasswordPage.confirmPasswordLabel), 'hello123');
          await tap(page.getter.getButtonText(nextButton), tester);
          expect(handler.lastEvent, UserJourneyController.nextEvent);
          var output = handler.lastOutput as CapturePasswordStateOutput;
          expect(output.password, 'hello123');
          // there is no error message
          checkFormError('');
        });
  });


}
