import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/widgets/named_item_widgets.dart';
import '../util.dart';

void main() {
  var value = 0;

  setUp(() {
    value = 0;
  });

  group('Test NamedItemTile', () {
    testWidgets('When I add a NamedItemTile to a page I expect the widget to show the correct Widgets',
        (WidgetTester tester) async {
      MockPage page = MockPage(NamedItemTile(
        item: MockNamedItem('Hello', 'YouTube'),
        actionIcon: Icons.add,
        enabled: true,
        selected: false,
      ));

      await tester.pumpWidget(page);

      expect(find.text('Hello'), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => (widget is ListTile && !widget.selected)), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => (widget is ListTile && (widget.leading is Icon))), findsOneWidget);
      expect(
          find.byWidgetPredicate((widget) => (widget is ListTile && (widget.trailing is IconButton))), findsOneWidget);
    });

    testWidgets(
        'When I add a NamedItemTile without an actionIcon and with an unexpected type I do not expect to see a leading or trailing widget',
        (WidgetTester tester) async {
      MockPage page = MockPage(NamedItemTile(
        item: MockNamedItem('Hello', 'Dummy'),
        enabled: true,
        selected: false,
      ));

      await tester.pumpWidget(page);

      expect(find.text('Hello'), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => (widget is ListTile && !widget.selected)), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => (widget is ListTile && (widget.leading == null))), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => (widget is ListTile && (widget.trailing == null))), findsOneWidget);
    });

    testWidgets(
        'When I add a NamedItemTile to a page with a function and I click the action I expect the function to be executed',
        (WidgetTester tester) async {
      MockPage page = MockPage(NamedItemTile(
        item: MockNamedItem('Hello', 'YouTube'),
        actionIcon: Icons.add,
        onPressed: () {
          value++;
        },
        enabled: true,
        selected: false,
      ));

      await tester.pumpWidget(page);
      await tapIcon(Icons.add, tester);
      expect(value, 1);
    });
  });

  group('Test DraggableNamedItem', ()
  {
    testWidgets('When I add a DraggableNamedItem to a page I expect the widget to show the correct Widgets',
            (WidgetTester tester) async {
          MockPage page = MockPage(DraggableNamedItem(
            item: MockNamedItem('Hello', 'YouTube'),
            actionIcon: Icons.add,

          ));

          await tester.pumpWidget(page);


        });
  });
}

class MockNamedItem implements NamedItem {
  @override
  String name;
  @override
  String type;

  MockNamedItem(this.name, this.type);
}
