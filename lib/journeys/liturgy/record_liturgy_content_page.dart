


import 'package:jericho/journeys/event_handler.dart';

abstract class RecordLiturgyContentStateInput implements StepInput {
  String get name;
  String get messageReference;
  String get content;
}

class RecordLiturgyContentDynamicState implements RecordLiturgyContentStateOutput {

  String content = '';
}

abstract class RecordLiturgyContentStateOutput implements StepOutput {
  String get content;
}