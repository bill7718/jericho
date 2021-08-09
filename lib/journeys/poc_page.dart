import 'dart:async';

import 'package:flutter/material.dart';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:waterloo/waterloo_file_uploader.dart';
import 'package:waterloo/waterloo_text_button.dart';


///
/// The main Landing Page for the application
///
class POCPage extends StatelessWidget {
  static const String titleRef = 'landingPage';


  final EventHandler handler;

  //https://pub.dev/packages/native_pdf_view/example

  const POCPage({Key? key, this.handler = const POCEventHandler()})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {

    return WaterlooFileUploader(exceptionHandler: handler.handleEvent, callback: (data) {
      print(data.fileName);
    });


  }
}

class POCEventHandler implements EventHandler {
  const POCEventHandler();

  @override
  Future<void> handleEvent(context, {String event = '', StepOutput output = UserJourneyController.emptyOutput}) {
    var c = Completer<void>();
    c.complete();
    return c.future;
  }

  @override
  void handleException(context, Exception ex, StackTrace? st) {}
}


