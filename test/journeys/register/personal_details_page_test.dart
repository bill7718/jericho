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

  group('Test Personal Details Page', () {
    testWidgets(
        'When the system initiates the journey the system shows the CapturePersonalDetails page and a lower level.',
        (WidgetTester tester) async {
      await controller.handleEvent(context, event: UserJourneyController.initialEvent);
      expect(navigator.currentRoute, RegisterJourneyController.personalDetailsRoute);
      expect(navigator.level, 1);
    });


  });


}
