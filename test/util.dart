import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/journeys/validators.dart';
import 'package:jericho/services/organisation_services.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_message.dart';
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
  /// It uses mock providers by default - these can be overridden using the [providers] parameter
  ///
  MockPage(this.child, {Key? key, this.providers = const <Provider>[]}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Validator validator = Validator(getter);
    final OrganisationValidator orgValidator = OrganisationValidator(getter);
    var defaultProviders = <Provider>[
      Provider<UserJourneyNavigator>.value(value: navigator),
      Provider<ConfigurationGetter>.value(value: getter),
      Provider<Validator>.value(value: validator),
      Provider<OrganisationValidator>.value(value: orgValidator),
    ];

    var p = <Provider>[];
    p.addAll(providers);
    if (p.isEmpty) {
      p.addAll(defaultProviders);
    }

    return MultiProvider(providers: p, child: MaterialApp(home: child));
  }
}

Finder findAppBarByTitle(String title) {
  Finder f = find.byWidgetPredicate((widget) => widget is AppBar);
  Finder f2 = find.descendant(of: f, matching: find.text(title));
  return f2;
}

Finder findTextInputFieldByLabel(String label, { bool obscure  = false}) {
  Finder f = find.byWidgetPredicate((widget) => widget is WaterlooTextField && widget.label == label && widget.obscure == obscure);
  return f;
}

Finder findUnexpectedTextInputFields(List<String> expectedLabels) {
  Finder f = find.byWidgetPredicate((widget) => widget is WaterlooTextField && !expectedLabels.contains(widget.label));
  return f;
}

void checkTextInputFields(List<String> expectedLabels, { bool obscure = false }) {
  for (var label in expectedLabels) {
    Finder f = find.byWidgetPredicate((widget) => widget is WaterlooTextField && widget.label == label && widget.obscure == obscure);
    expect(f, findsOneWidget);
  }

  expect(findUnexpectedTextInputFields(expectedLabels), findsNothing);
}

Future<void> enterText(WidgetTester tester, String label, String text, { obscure = false}) {
  var c = Completer<void>();
  tester.enterText(findTextInputFieldByLabel(label, obscure: obscure), text).then((v) {
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
  await tester.pumpAndSettle();
  c.complete();
  return c.future;
}

Finder findButtonByText(String text) {
  Finder f = find.byWidgetPredicate((widget) => widget is WaterlooTextButton && widget.text == text);
  return f;
}

Finder findUnexpectedButtons(List<String> expectedButtons) {
  Finder f = find.byWidgetPredicate((widget) => widget is WaterlooTextButton && !expectedButtons.contains(widget.text));
  return f;
}

void checkButtons(List<String> expectedButtons) {
  for (var text in expectedButtons) {
    Finder f = find.byWidgetPredicate((widget) => widget is WaterlooTextButton && widget.text == text);
    expect(f, findsOneWidget);
  }

  expect(findUnexpectedButtons(expectedButtons), findsNothing);
}

void checkFormError(String message) {
  Finder f = find.byWidgetPredicate((widget) => widget is WaterlooFormMessage && widget.error.error == message);
  expect(f, findsOneWidget);
}

Future<void> wait({Duration duration = const Duration(milliseconds: 500)}) {
  final c = Completer<void>();

  Timer(duration, () {
    c.complete();
  });

  return c.future;
}
