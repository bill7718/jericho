import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

///
/// Tap a button
///
StepDefinitionGeneric tapButton() {
  return then1<String, FlutterWorld>(
    RegExp('I tap the {string} button'),
    (label, context) async {
      final f = find.ancestor(of: find.text(label), matching: find.byType('WaterlooTextButton'));

      context.expectMatch(await FlutterDriverUtils.isPresent(context.world.driver, f), true,
          reason: 'Cannot tap button $label as this button cannot be found');
      await FlutterDriverUtils.tap(context.world.driver, f);
    },
  );
}
