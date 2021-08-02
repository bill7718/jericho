import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'hooks/write_screenshots.dart';
import 'steps/check_widget_present.dart';
import 'steps/enter_text.dart';


Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/*.feature")]
    ..reporters = [
      //ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: 'test_driver/report.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..hooks = [ AttachScreenshotOnExpectAndTapHook(), AttachScreenshotOnEveryStepHook() ]
    ..stepDefinitions = [IsTextInputPresent(), CurrentPage(), enterText()]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";
  // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
  return GherkinRunner().execute(config);
}