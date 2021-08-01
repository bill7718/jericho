




import 'package:jericho/journeys/event_handler.dart';

abstract class CapturePasswordStateInput implements StepInput {

  String get password;
  String get messageReference;
  String get message;


}

abstract class CapturePasswordStateOutput implements StepOutput {
  String get password;
}

class  CapturePasswordDynamicState implements CapturePasswordStateOutput {

  @override
  String password;
  String copyPassword;

  CapturePasswordDynamicState(this.password, this.copyPassword);

}