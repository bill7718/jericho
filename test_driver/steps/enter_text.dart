import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric enterText() {
  return then2<String, String, FlutterWorld>(
    RegExp('I enter {string} in {string}'),
        (text, label, context) async {
      final f = find.ancestor(of: find.text(label), matching: find.byType('WaterlooTextField'));

      context.expectMatch(await FlutterDriverUtils.isPresent(context.world.driver, f), true,
          reason: 'Cannot enter $text in $label as this field cannot be found');

      await FlutterDriverUtils.enterText(context.world.driver, f, text);
    },
  );
}