import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:waterloo/waterloo_text_field.dart';

import 'mocks/journeys/configuration/mock_configuration.dart';
import 'mocks/mocks.dart';

class MockPage extends StatelessWidget {
  final Widget child;
  final navigator = MockUserNavigator();
  final getter = MockConfigurationGetter();
  final List<Provider> providers;

  ///
  /// A Mock Page that accepts the child widget to be tested.
  /// It users mock providers by default - these can be overridden using the [providers] parameter
  ///
  MockPage(this.child, {Key? key, this.providers = const <Provider>[]}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultProviders = <Provider>[
      Provider<UserJourneyNavigator>.value(value: navigator),
      Provider<ConfigurationGetter>.value(value: getter)
    ];

    var p = <Provider>[];
    p.addAll(providers);
    if (p.isEmpty) {
      p.addAll(defaultProviders);
    }

    return MultiProvider(providers: p, child: MaterialApp(home: Card(child: child)));
  }
}

Finder findTextInputFieldByLabel(String label) {
  Finder f = find.byWidgetPredicate((widget) => widget is WaterlooTextField && widget.label == label);
  return f;
}

Future<void> enterText(WidgetTester tester, String label, String text) {
  var c = Completer<void>();
  tester.enterText(findTextInputFieldByLabel(label), text).then((v) {
    tester.pumpAndSettle().then((value) {
      c.complete();
    });
  });

  return c.future;
}

Future<void> tap(String text, WidgetTester tester) async {
  var c = Completer<void>();
  var f = find.byWidgetPredicate((widget) => widget is WaterlooTextButton && widget.text == text);
  expect(f, findsOneWidget);
  await tester.tap(f);
  c.complete();
  return c.future;
}

Finder findButtonByText(String text) {
  Finder f = find.byWidgetPredicate((widget) => widget is WaterlooTextButton && widget.text == text);
  return f;
}

Future<void> wait({Duration duration = const Duration(milliseconds: 500)}) {
  final c = Completer<void>();

  var t = Timer(duration, () {
    c.complete();
  });

  return c.future;
}
