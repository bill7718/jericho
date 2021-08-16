import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/service/service_item.dart';

import '../../mocks/mocks.dart';

void main() {

  var mapWithText = <String, dynamic> {
    'name': 'my Name is John',
    'type': 'myType',
    'text': 'The quick brown fox jumped over the lazy dog'
  };

  var mapWithoutText = <String, dynamic> {
    'name': 'my Name is Colin',
    'type': 'myType',
  };

  var serviceItemWithText = ServiceItem(mapWithText);
  var serviceItemWithoutText = ServiceItem(mapWithoutText);

  setUp(() async {


  });

  group('Test service item', () {
    testWidgets('I retrieve the name and type of a service item the correct values are returned  ', (WidgetTester tester) async {
      expect(serviceItemWithText.name, mapWithText['name']);
      expect(serviceItemWithText.type, mapWithText['type']);
      expect(serviceItemWithText.data.length, 3);
    });

    testWidgets('When I compute the score for a service item with no matching value I expect zero ', (WidgetTester tester) async {
      expect(serviceItemWithText.score('Bill'), 0);
      expect(serviceItemWithoutText.score('Bill'), 0);
    });

    testWidgets('When I compute the score for a service item with a single match on name I expect the value to be calculated correctly ', (WidgetTester tester) async {
      expect(serviceItemWithText.score('John'), 1600);
      expect(serviceItemWithoutText.score('Colin'), 2500);
    });

    testWidgets('When I compute the score for a service item with more than one match on name I expect the value to be calculated correctly ', (WidgetTester tester) async {
      expect(serviceItemWithText.score('John name'), 3200);
      expect(serviceItemWithoutText.score('Colin name'), 4100);
    });

    testWidgets('When I compute the score for a service item with a single match on name  and one text I expect the value to be calculated correctly ', (WidgetTester tester) async {
      expect(serviceItemWithText.score('John fox'), 1690);
      expect(serviceItemWithoutText.score('Colin fox'), 2500);
    });

    testWidgets('When I clone the data I expect it to be the same ', (WidgetTester tester) async {
      expect(serviceItemWithText.clone().name, serviceItemWithText.name);
      expect(serviceItemWithoutText.clone().score('Colin fox'), serviceItemWithoutText.score('Colin fox'));
    });

  });
}
