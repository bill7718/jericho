import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/login/login_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/journeys/validators.dart';

import '../../mocks/mocks.dart';
import '../../util.dart';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();

  });

  group('Test Login Page', () {
    testWidgets(
        'When the system initiates Login Page the correct widgets are shown',
        (WidgetTester tester) async {
          MockPage page = MockPage( LoginPage (eventHandler: handler, inputState: MockLoginStateInput(),));
          await tester.pumpWidget(page);

          expect(findAppBarByTitle(page.getter.getPageTitle(LoginPage.titleRef)), findsOneWidget);
          expect(findTextInputFieldByLabel(page.getter.getLabel(emailLabel)), findsOneWidget);
          expect(findTextInputFieldByLabel(page.getter.getLabel(passwordLabel) , obscure: true), findsOneWidget);
          checkButtons([page.getter.getButtonText(nextButton), page.getter.getButtonText(previousButton)]);

          // there is no error message
          checkFormError('');
    });

    testWidgets(
        'When the system initiates Login Page with data already provided then this data is shown',
            (WidgetTester tester) async {
          MockPage page = MockPage( LoginPage (eventHandler: handler, inputState: MockLoginStateInput(email: 'a@b.com', password: 'hello123'),));
          await tester.pumpWidget(page);

          expect(find.text('a@b.com'), findsOneWidget);
          expect(find.text('hello123'), findsOneWidget);
          // there is no error message
          checkFormError('');
        });

    testWidgets(
        'When the system initiates PLogin Page with an error message then this is shown',
            (WidgetTester tester) async {
          MockPage page = MockPage( LoginPage (eventHandler: handler, inputState: MockLoginStateInput(messageReference: 'error1'),));
          await tester.pumpWidget(page);
          // there is an error message
          checkFormError(page.getter.getErrorMessage('error1'));
        });


    testWidgets(
        'When the user clicks the previous button the system invokes the previous event' ,
            (WidgetTester tester) async {
              MockPage page = MockPage( LoginPage (eventHandler: handler, inputState: MockLoginStateInput(),));
              await tester.pumpWidget(page);
              await tap(page.getter.getButtonText(previousButton), tester);
              expect(handler.lastEvent, UserJourneyController.backEvent);

    });

    testWidgets(
        'When the user clicks the next button without any data input the system does not invoke an event and error messages are shown' ,
            (WidgetTester tester) async {
          MockPage page = MockPage( LoginPage (eventHandler: handler, inputState: MockLoginStateInput(),));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(nextButton), tester);
          expect(handler.lastEvent, '');
          expect(find.text(page.getter.getErrorMessage(Validator.emailError)), findsOneWidget);
          expect(find.text(page.getter.getErrorMessage(Validator.passwordError)), findsOneWidget);
        });

    testWidgets(
        'When the user clicks the next button with valid input the next event is sent with the correct data' ,
            (WidgetTester tester) async {
          MockPage page = MockPage( LoginPage (eventHandler: handler, inputState: MockLoginStateInput(),));
          await tester.pumpWidget(page);
          await enterText(tester, page.getter.getLabel(emailLabel), 'a@b.com');
          await enterText(tester, page.getter.getLabel(passwordLabel), 'hello12345', obscure: true);
          await tap(page.getter.getButtonText(nextButton), tester);
          expect(handler.lastEvent, UserJourneyController.nextEvent);
          var output = handler.lastOutput as LoginStateOutput;
          expect(output.password, 'hello12345');
          expect(output.email, 'a@b.com');

        });
  });


}

class MockLoginStateInput implements LoginStateInput  {
  @override
  final String email;

  @override
  final String password;


  @override
  final String messageReference;

  MockLoginStateInput({this.email = '', this.password = '',  this.messageReference = ''} );


}