




import 'package:jericho/journeys/event_handler.dart';

abstract class CapturePasswordStateInput implements StepInput {

  String get password;
  String get messageReference;


}

class CapturePasswordStateOutput implements StepOutput {
  final String password;

  CapturePasswordStateOutput(this.password);

}

class  CapturePasswordDynamicState {

  String password;
  String copyPassword;

  CapturePasswordDynamicState(this.password, this.copyPassword);

}