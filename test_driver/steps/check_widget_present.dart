

import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric IsTextInputPresent()  {
  return when1<String, FlutterWorld>(
    RegExp('I expect the {string} to be present'),
        (label, context) async {

      final locator = find.ancestor(of: find.text(label), matching: find.byType('WaterlooTextField'));
      context.expectMatch(await FlutterDriverUtils.isPresent(context.world.driver, locator), true);
    },
  );
}


///
/// Determine the current page by looking at the title of the App Bar
///
StepDefinitionGeneric CurrentPage()  {
  return when1<String, FlutterWorld>(
    RegExp('I expect the current page to be the {string} page'),
        (label, context) async {
      //final locator = find.text(label);

      final locator = find.ancestor(of: find.text(label), matching: find.byType('AppBar'));

      context.expectMatch(await FlutterDriverUtils.isPresent(context.world.driver, locator), true);
    },
  );
}