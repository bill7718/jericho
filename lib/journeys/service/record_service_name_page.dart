


import 'package:jericho/journeys/event_handler.dart';

class RecordServiceNameStateInput extends StepInput {

  final String name;

  RecordServiceNameStateInput( {this.name = '' });
}


abstract class RecordServiceNameStateOutput extends StepOutput {

  String get name;


}