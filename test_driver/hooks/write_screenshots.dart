
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:meta/meta.dart';

class WriteScreenshotOnFailedStepHook extends Hook {
  @override
  Future<void> onAfterStep(
    World world,
    String step,
    StepResult stepResult,
  ) async {
    if (stepResult.result == StepExecutionResult.fail ||
        stepResult.result == StepExecutionResult.error ||
        stepResult.result == StepExecutionResult.timeout) {
      try {
        final screenshotData = await takeScreenshot(world);
        File f = File('test_driver/error.png');
        f.writeAsBytesSync(screenshotData);
      } catch (e, st) {
        world.attach('Failed to take screenshot\n$e\n$st', 'text/plain', step);
      }
    }
  }

  @protected
  Future<List<int>> takeScreenshot(World world) async {

    final bytes = await (world as FlutterWorld).driver?.screenshot();

    return bytes ?? <int>[];
  }
}

class AttachScreenshotOnEveryStepHook  extends Hook {

  @override
  Future<void> onAfterStep(
    World world,
    String step,
    StepResult stepResult,
  ) async {
    try {
      final screenshotData = await takeScreenshot(world);
      world.attach(screenshotData, 'image/png', step);
    } catch (e, st) {
      world.attach('Failed to take screenshot\n$e\n$st', 'text/plain', step);
    }

  }

  @protected
  Future<String> takeScreenshot(World world) async {
    final bytes = await (world as FlutterWorld).driver?.screenshot();

    return base64Encode(bytes ?? <int>[]);
  }
}

class AttachScreenshotOnExpectAndTapHook  extends Hook {

  @override
  Future<void> onAfterStep(
      World world,
      String step,
      StepResult stepResult,
      ) async {
    try {
      if (step.contains('expect') || step.contains('tap')  || step.contains('screenshot')) {
        final screenshotData = await takeScreenshot(world);
        world.attach(screenshotData, 'image/png', step);
      }

    } catch (e, st) {
      world.attach('Failed to take screenshot\n$e\n$st', 'text/plain', step);
    }

  }

  @protected
  Future<String> takeScreenshot(World world) async {
    final bytes = await (world as FlutterWorld).driver?.screenshot();

    return base64Encode(bytes ?? <int>[]);
  }
}
