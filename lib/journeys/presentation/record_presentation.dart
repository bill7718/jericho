
import 'dart:typed_data';
import 'package:jericho/journeys/event_handler.dart';

abstract class RecordPresentationStepInput implements StepInput {
  String get name;
  String get messageReference;
}

class RecordPresentationDynamicState implements RecordPresentationStateOutput {
  String name = '';
  Uint8List data = Uint8List(0);
}


abstract class RecordPresentationStateOutput {

  String get name;
  Uint8List get data;
}
